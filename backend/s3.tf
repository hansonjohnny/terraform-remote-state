# S3 Bucket for Terraform State - STARTER FILE
# ==============================================
# TODO: Create an S3 bucket to store Terraform state files!
#
# What is an S3 bucket?
#   - S3 = Simple Storage Service (like a cloud hard drive)
#   - Stores files called "objects" in "buckets"
#   - Perfect for storing Terraform state files
#
# Why store state in S3?
#   - Team members can share state
#   - State is backed up automatically
#   - Can enable versioning to see history
#   - Can encrypt for security
#
# Requirements:
#   1. Create an S3 bucket with a unique name
#   2. Enable versioning (keeps history of state changes)
#   3. Enable encryption (protects sensitive data)
#   4. Block public access (security!)
#
# See README.md for detailed explanations!

# =============================================================================
# STEP 1: Create the S3 Bucket
# =============================================================================
# TODO: Uncomment and create the S3 bucket
#
# The bucket name comes from local.bucket_name (defined in main.tf)
# It includes a random suffix to make it globally unique
#
resource "aws_s3_bucket" "terraform_state" {
  bucket = local.bucket_name

  # Prevent accidental deletion of this important bucket!
  # In production, set this to true
  force_destroy = true  # Set to false in production!

  tags = {
    Name        = "Terraform State Bucket"
    Purpose     = "terraform-state"
    Environment = var.environment
  }
}

# =============================================================================
# STEP 2: Enable Versioning
# =============================================================================
# TODO: Enable versioning on the bucket
#
# Versioning keeps every version of your state file.
# If something goes wrong, you can recover a previous version!
#
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# =============================================================================
# STEP 3: Enable Server-Side Encryption
# =============================================================================
# TODO: Enable encryption for the bucket
#
# State files contain sensitive information (passwords, keys, etc.)
# Encryption protects this data at rest in S3.
#
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      # AES256 is the simplest encryption option
      # For higher security, use "aws:kms" with a KMS key
      sse_algorithm = "AES256"
    }
  }
}

# =============================================================================
# STEP 4: Block Public Access
# =============================================================================
# TODO: Block all public access to the bucket
#
# State files should NEVER be public!
# This setting prevents accidental public exposure.
#
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  # Block all four types of public access
  block_public_acls       = true   # Block public ACLs
  block_public_policy     = true   # Block public bucket policies
  ignore_public_acls      = true   # Ignore any public ACLs
  restrict_public_buckets = true   # Restrict public bucket policies
}
