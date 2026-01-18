# Backend Infrastructure - Main Configuration
# ============================================
# This creates the S3 bucket and DynamoDB table needed
# for Terraform remote state storage.
#
# Run this FIRST before other modules!

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# =============================================================================
# Provider Configuration
# =============================================================================
# This configures the AWS provider to work with either:
# - LocalStack (for local development/testing)
# - Real AWS (for production use)

provider "aws" {
  region = var.aws_region

  # LocalStack configuration (ignored when use_localstack = false)
  dynamic "endpoints" {
    for_each = var.use_localstack ? [1] : []
    content {
      s3       = var.localstack_endpoint
      dynamodb = var.localstack_endpoint
      iam      = var.localstack_endpoint
      sts      = var.localstack_endpoint
    }
  }

  # LocalStack requires these settings
  skip_credentials_validation = var.use_localstack
  skip_metadata_api_check     = var.use_localstack
  skip_requesting_account_id  = var.use_localstack

  # For LocalStack, use test credentials
  # For real AWS, use your actual credentials (via AWS CLI profile or env vars)
  access_key = var.use_localstack ? "test" : null
  secret_key = var.use_localstack ? "test" : null

  default_tags {
    tags = var.tags
  }
}

# =============================================================================
# Random Suffix for Unique Bucket Name
# =============================================================================
# S3 bucket names must be globally unique, so we add a random suffix

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# =============================================================================
# Local Values
# =============================================================================

locals {
  bucket_name = "${var.project_name}-${var.environment}-${random_id.bucket_suffix.hex}"
  table_name  = "${var.project_name}-lock"
}
