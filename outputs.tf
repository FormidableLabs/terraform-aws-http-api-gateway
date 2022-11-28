output "api" {
  value = aws_apigatewayv2_api.this
}

output "route53_record" {
  value = aws_route53_record.this
}

output "apig_stage" {
  value = aws_apigatewayv2_stage.this
}
