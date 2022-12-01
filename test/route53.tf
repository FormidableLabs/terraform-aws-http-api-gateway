resource "aws_acm_certificate" "certificate" {
  domain_name               = "example.com"
  validation_method         = "DNS"
  subject_alternative_names = ["*.example.com"]
}

resource "aws_acm_certificate_validation" "certificate-validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert-validation : record.fqdn]
}

resource "aws_route53_zone" "api_zone" {
  name    = "example.com"
  comment = "Test Route 53 zone"
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.api_zone.zone_id
}
