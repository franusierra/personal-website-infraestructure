resource "aws_s3_bucket" "s3_bucket" {
   bucket = var.personal_website_domain
   acl    = "public-read"
   policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"AddPerm",
    "Effect":"Allow",
    "Principal": "*",
    "Action":["s3:GetObject"],
    "Resource":["arn:aws:s3:::${var.personal_website_domain}/*"]
  }]
}
POLICY
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}


/**
	Define CloudFront Distribution
    - It will use the SSL certificate
    - It will redirect all the http traffic to https.
*/
resource "aws_cloudfront_distribution" "frontend_cloudfront_distribution" {
  origin {
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
    domain_name = aws_s3_bucket.s3_bucket.website_endpoint
    origin_id   = var.personal_website_domain
  }
  
  enabled             = true
  default_root_object = "index.html"
  
  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.personal_website_domain
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  
  custom_error_response {
    error_caching_min_ttl = 3000
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }
  
  aliases = [var.personal_website_domain]
  
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.ssl_cert.arn
    ssl_support_method  = "sni-only"
  }
}
