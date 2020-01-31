resource "aws_s3_bucket" "s3_bucket" {
  bucket        = var.bucket_name
  acl           = var.public_bucket ? "public-read" : "private"
  force_destroy = var.force_destroy

  versioning {
    enabled = var.versioned
  }

  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    allowed_origins = [var.cors_allowed_origins]
    expose_headers  = var.cors_expose_headers
    max_age_seconds = var.cors_max_age_seconds
  }

  tags = var.bucket_tags
}

resource "aws_transfer_server" "transfer_server" {
  identity_provider_type = "SERVICE_MANAGED"
  logging_role           = aws_iam_role.transfer_server_role.arn

  tags = {
    NAME = var.transfer_server_name
  }
}

resource "aws_transfer_user" "transfer_server_user" {
  server_id      = aws_transfer_server.transfer_server.id
  user_name      = var.transfer_server_user_name
  role           = aws_iam_role.transfer_server_role.arn
  home_directory = "/${aws_s3_bucket.s3_bucket.id}"
}

resource "aws_transfer_ssh_key" "transfer_server_ssh_key" {
  server_id = aws_transfer_server.transfer_server.id
  user_name = aws_transfer_user.transfer_server_user.user_name
  body      = var.transfer_server_ssh_key
}
