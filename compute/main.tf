# Compute Configuration - Main File with Remote Backend
# ======================================================
# This demonstrates using the S3 remote backend!
#
# IMPORTANT: Run the backend/ module FIRST to create the S3 bucket
# and DynamoDB table before running this module.
#
# Steps:
#   1. Complete backend/ module first
#   2. Copy the outputs (bucket name, table name, region)
#   3. Update the backend configuration below
#   4. Run: terraform init
#   5. Run: terraform plan
#   6. Run: terraform apply

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }

  # ===========================================================================
  # TODO: Configure the S3 Remote Backend
  # ===========================================================================
  # Uncomment this block AFTER creating the backend resources!
  #
  # Replace the values with outputs from the backend/ module:
  #   - bucket: from output "state_bucket_name"
  #   - dynamodb_table: from output "lock_table_name"
  #   - region: from output "aws_region"
  #
  # backend "s3" {
  #   bucket         = "terraform-state-dev-xxxxxxxx"  # Your bucket name
  #   key            = "compute/terraform.tfstate"     # Path in the bucket
  #   region         = "us-east-1"                     # AWS region
  #   encrypt        = true                            # Enable encryption
  #   dynamodb_table = "terraform-state-lock"          # Lock table name
  #
  #   # For LocalStack only - remove these for real AWS!
  #   skip_credentials_validation = true
  #   skip_metadata_api_check     = true
  #   force_path_style            = true
  #   endpoints = {
  #     s3       = "http://localhost:4566"
  #     dynamodb = "http://localhost:4566"
  #   }
  # }
}

# Provider Configuration
provider "aws" {
  region = var.aws_region

  dynamic "endpoints" {
    for_each = var.use_localstack ? [1] : []
    content {
      s3       = var.localstack_endpoint
      dynamodb = var.localstack_endpoint
      iam      = var.localstack_endpoint
      ec2      = var.localstack_endpoint
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

# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get a subnet in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
