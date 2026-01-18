# IAM Configuration - Main File
# ==============================
# This creates IAM users and policies for Terraform access.
#
# What is IAM?
#   - IAM = Identity and Access Management
#   - Controls WHO can do WHAT in AWS
#   - Users = people or services
#   - Policies = rules about what's allowed
#   - Access Keys = username/password for programmatic access

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider Configuration (same pattern as backend/)
provider "aws" {
  region = var.aws_region

  dynamic "endpoints" {
    for_each = var.use_localstack ? [1] : []
    content {
      s3       = var.localstack_endpoint
      dynamodb = var.localstack_endpoint
      iam      = var.localstack_endpoint
      sts      = var.localstack_endpoint
    }
  }

  skip_credentials_validation = var.use_localstack
  skip_metadata_api_check     = var.use_localstack
  skip_requesting_account_id  = var.use_localstack

  access_key = var.use_localstack ? "test" : null
  secret_key = var.use_localstack ? "test" : null

  default_tags {
    tags = var.tags
  }
}

# Get the current AWS account ID
data "aws_caller_identity" "current" {}
