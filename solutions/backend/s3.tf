# S3 Bucket for Terraform State - SOLUTION
# =========================================

# The S3 bucket stores your Terraform state files
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.project_name}-tfstate-${var.environment}"

  # Prevent accidental deletion
  lifecycle {
    prevent_destroy = false  # Set to true in production!
  }

  tags = {
    Name        = "${var.project_name}-tfstate"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Terraform State Storage"
  }
}

# Enable versioning to keep history of state files
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
