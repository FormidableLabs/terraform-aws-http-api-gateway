[![terraform-aws-http-api-gateway — Formidable, We build the modern web](https://raw.githubusercontent.com/FormidableLabs/terraform-aws-http-api-gateway/main/terraform-aws-http-api-gateway-Hero.png)](https://formidable.com/open-source/)

[![Maintenance Status][maintenance-image]](#maintenance-status)

## Purpose

This module creates resources required for a HTTP AWS API Gateway (v2) when provided an _existing_ Lambda Function and Route53 Hosted Zone. This module utilizes the the [FormidableLabs/terraform-aws-platform](https://github.com/FormidableLabs/terraform-aws-platform) module to create a _regionally_ identifable Route53 Record (e.g `use1-production-unsubscriber.example.com`) to access the API Gateway.

## Example Usage

```
module "apigateway" {
  source = "github.com/FormidableLabs/terraform-aws-http-api-gateway?ref=v0.1"

  domain_name                = var.domain_name
  lambda_function_invoke_arn = var.lambda_function_invoke_arn
  namespace                  = var.namespace
  service                    = var.service
  stage                      = var.stage
  enable_access_logs         = var.enable_apig_logs
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_platform"></a> [platform](#module\_platform) | github.com/FormidableLabs/terraform-aws-platform | v0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_api.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api) | resource |
| [aws_apigatewayv2_api_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api_mapping) | resource |
| [aws_apigatewayv2_domain_name.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_domain_name) | resource |
| [aws_apigatewayv2_integration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration) | resource |
| [aws_apigatewayv2_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route) | resource |
| [aws_apigatewayv2_stage.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage) | resource |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_lambda_permission.apigw_lambda_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_acm_certificate.wildcard](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_servicequotas_service_quota.throttling_burst_limit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/servicequotas_service_quota) | data source |
| [aws_servicequotas_service_quota.throttling_rate_limit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/servicequotas_service_quota) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Top level domain name. | `string` | `"example.com"` | no |
| <a name="input_enable_access_logs"></a> [enable\_access\_logs](#input\_enable\_access\_logs) | Enable API Gateway Access Logs | `bool` | `false` | no |
| <a name="input_enable_quota_limits"></a> [enable\_quota\_limits](#input\_enable\_quota\_limits) | n/a | `bool` | `true` | no |
| <a name="input_lambda_function_invoke_arn"></a> [lambda\_function\_invoke\_arn](#input\_lambda\_function\_invoke\_arn) | (Required) ARN of the lambda the API Gateway will invoke. | `string` | n/a | yes |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | Log retention in number of days. | `number` | `90` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | n/a | `string` | `""` | no |
| <a name="input_service"></a> [service](#input\_service) | n/a | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to the log group. | `map(any)` | `{}` | no |
| <a name="input_throttling_burst_limit"></a> [throttling\_burst\_limit](#input\_throttling\_burst\_limit) | n/a | `number` | `null` | no |
| <a name="input_throttling_rate_limit"></a> [throttling\_rate\_limit](#input\_throttling\_rate\_limit) | n/a | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api"></a> [api](#output\_api) | n/a |
| <a name="output_apig_stage"></a> [apig\_stage](#output\_apig\_stage) | n/a |
| <a name="output_route53_record"></a> [route53\_record](#output\_route53\_record) | n/a |
<!-- END_TF_DOCS -->

[maintenance-image]: https://img.shields.io/badge/maintenance-active-green.svg?color=brightgreen&style=flat

## Maintenance Status

**Active:** Formidable is actively working on this project, and we expect to continue for work for the foreseeable future. Bug reports, feature requests and pull requests are welcome.
