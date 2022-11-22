# terraform-aws-http-api-gateway

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

[maintenance-image]: https://img.shields.io/badge/maintenance-active-green.svg?color=brightgreen&style=flat

## Maintenance Status

**Active:** Formidable is actively working on this project, and we expect to continue for work for the foreseeable future. Bug reports, feature requests and pull requests are welcome.
