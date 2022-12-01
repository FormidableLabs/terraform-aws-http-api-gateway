locals {
  account_id   = module.platform.account_id
  partition    = module.platform.partition
  region       = module.platform.region
  region_short = module.platform.region_short
  name         = join("-", compact([local.region_short, var.stage, var.namespace, var.service]))
  dns_prefix   = join("-", compact([local.region_short, var.namespace, var.service]))

  tags = merge(var.tags, {
    TerraformModule = "api-gateway"
  })
}

module "platform" {
  # uses the FormidableLabs/terraform-aws-platform
  source = "github.com/FormidableLabs/terraform-aws-platform?ref=v0.1"
}

data "aws_acm_certificate" "wildcard" {
  domain = "*.${var.domain_name}"
}

data "aws_route53_zone" "this" {
  name = "${var.domain_name}."
}

resource "aws_cloudwatch_log_group" "this" {
  count = var.enable_access_logs ? 1 : 0
  name  = "/aws/api-gateway/${local.name}"

  retention_in_days = var.log_retention_in_days

  tags = local.tags
}

resource "aws_apigatewayv2_api" "this" {
  name          = local.name
  protocol_type = "HTTP"

  cors_configuration {
    allow_headers  = ["*"]
    allow_methods  = ["*"]
    allow_origins  = ["*"]
    expose_headers = ["*"]
    max_age        = 1000
  }

  tags = local.tags
}

resource "aws_apigatewayv2_stage" "this" {
  name   = "$default"
  api_id = aws_apigatewayv2_api.this.id

  auto_deploy = true


  dynamic "access_log_settings" {
    for_each = var.enable_access_logs ? [0] : []

    content {
      destination_arn = aws_cloudwatch_log_group.this[0].arn

      # https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html#apigateway-cloudwatch-log-formats
      format = trimspace(jsonencode({
        requestId                = "$context.requestId"
        requestTime              = "$context.requestTime"
        httpMethod               = "$context.httpMethod"
        ip                       = "$context.identity.sourceIp"
        status                   = "$context.status"
        protocol                 = "$context.protocol"
        path                     = "$context.path"
        responseLatency          = "$context.responseLatency"
        responseLength           = "$context.responseLength"
        error                    = "$context.error.message"
        errorResponseType        = "$context.error.responseType"
        integrationError         = "$context.integration.error"
        integrationRequestId     = "$context.integration.requestId",
        functionResponseStatus   = "$context.integration.status",
        integrationLatency       = "$context.integration.latency",
        integrationServiceStatus = "$context.integration.integrationStatus"
      }))
    }
  }

  tags = local.tags
}

resource "aws_apigatewayv2_domain_name" "this" {
  domain_name = "${local.dns_prefix}.${var.domain_name}"

  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.wildcard.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = local.tags
}

resource "aws_apigatewayv2_api_mapping" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  domain_name = aws_apigatewayv2_domain_name.this.id
  stage       = aws_apigatewayv2_stage.this.id
}

resource "aws_apigatewayv2_route" "this" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.this.id}"
}

resource "aws_apigatewayv2_integration" "this" {
  api_id = aws_apigatewayv2_api.this.id

  description = "Lambda proxy integration"

  connection_type = "INTERNET"

  integration_uri    = var.lambda_function_invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_lambda_permission" "apigw_lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_invoke_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*/{proxy+}"
}

resource "aws_route53_record" "this" {
  name            = aws_apigatewayv2_domain_name.this.domain_name
  zone_id         = data.aws_route53_zone.this.id
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}
