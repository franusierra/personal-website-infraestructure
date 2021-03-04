data "aws_route53_zone" "zone" {
  name         = var.personal_website_domain
  private_zone = false
}

resource "aws_route53_record" "frontend_record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.personal_website_domain
  type    = "A"
  alias {
    name = aws_cloudfront_distribution.frontend_cloudfront_distribution.domain_name
    zone_id = aws_cloudfront_distribution.frontend_cloudfront_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

data "aws_acm_certificate" "ssl_cert" {
    provider = "aws.us-east-1"
    domain   = var.personal_website_domain
    statuses = ["ISSUED"]
}
