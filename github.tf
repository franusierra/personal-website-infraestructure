resource "aws_iam_user" "github_actions_frontend_dev" {
  name = "github_actions_frontend_dev"
  path = "/personal_website/github_actions/"
}

resource "aws_iam_access_key" "github_actions_frontend_access_key_dev" {
  user = aws_iam_user.github_actions_frontend_dev.name
}

resource "aws_iam_user_policy" "github_actions_frontend_policy_dev" {
  name = "update_react_app"
  user = aws_iam_user.github_actions_frontend_dev.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:DeleteObject",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
            "${aws_s3_bucket.dev_frontend_s3_bucket.arn}",
            "${aws_s3_bucket.dev_frontend_s3_bucket.arn}/*"
        ]
    }
  ]
}
EOF
}

resource "github_actions_secret" "frontend_s3_bucket_dev" {
  repository       = var.frontend_repo_name
  secret_name      = "PERSONAL_WEBSITE_S3_BUCKET_DEV"
  plaintext_value  = aws_s3_bucket.dev_frontend_s3_bucket.id
}

resource "github_actions_secret" "frontend_s3_bucket_region_dev" {
  repository       = var.frontend_repo_name
  secret_name      = "PERSONAL_WEBSITE_S3_BUCKET_REGION_DEV"
  plaintext_value  = aws_s3_bucket.dev_frontend_s3_bucket.region
}

resource "github_actions_secret" "frontend_access_key_id_dev" {
  repository       = var.frontend_repo_name
  secret_name      = "AWS_ACCESS_KEY_ID_DEV"
  plaintext_value  = aws_iam_access_key.github_actions_frontend_access_key_dev.id
}

resource "github_actions_secret" "frontend_access_key_secret_dev" {
  repository       = var.frontend_repo_name
  secret_name      = "AWS_SECRET_ACCESS_KEY_DEV"
  plaintext_value  = aws_iam_access_key.github_actions_frontend_access_key_dev.secret
}


resource "aws_iam_user" "github_actions_frontend" {
  name = "github_actions_frontend"
  path = "/personal_website/github_actions/"
}

resource "aws_iam_access_key" "github_actions_frontend_access_key" {
  user = aws_iam_user.github_actions_frontend.name
}

resource "aws_iam_user_policy" "github_actions_frontend_policy" {
  name = "update_react_app"
  user = aws_iam_user.github_actions_frontend.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:DeleteObject",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
            "${aws_s3_bucket.prod_frontend_s3_bucket.arn}",
            "${aws_s3_bucket.prod_frontend_s3_bucket.arn}/*"
        ]
    },
    {
      "Action": [
        "cloudfront:CreateInvalidation"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "github_actions_secret" "frontend_s3_bucket" {
  repository       = var.frontend_repo_name
  secret_name      = "PERSONAL_WEBSITE_S3_BUCKET"
  plaintext_value  = aws_s3_bucket.prod_frontend_s3_bucket.id
}

resource "github_actions_secret" "frontend_s3_bucket_region" {
  repository       = var.frontend_repo_name
  secret_name      = "PERSONAL_WEBSITE_S3_BUCKET_REGION"
  plaintext_value  = aws_s3_bucket.prod_frontend_s3_bucket.region
}

resource "github_actions_secret" "frontend_cloudfront_distribution" {
  repository       = var.frontend_repo_name
  secret_name      = "PERSONAL_WEBSITE_CLOUDFRONT_DISTRIBUTION_ID"
  plaintext_value  = aws_cloudfront_distribution.frontend_cloudfront_distribution.id
}
resource "github_actions_secret" "frontend_access_key_id" {
  repository       = var.frontend_repo_name
  secret_name      = "AWS_ACCESS_KEY_ID"
  plaintext_value  = aws_iam_access_key.github_actions_frontend_access_key.id
}
resource "github_actions_secret" "frontend_access_key_secret" {
  repository       = var.frontend_repo_name
  secret_name      = "AWS_SECRET_ACCESS_KEY"
  plaintext_value  = aws_iam_access_key.github_actions_frontend_access_key.secret
}

