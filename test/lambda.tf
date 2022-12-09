module "lambda" {
  source = "github.com/FormidableLabs/terraform-aws-lambda?ref=v0.1.0"

  filename = "lambda.zip"
  handler  = "index.handler"
  service  = "testLambda"
  stage    = "development"
  variables = {
    "STAGE" = "development"
  }
}
