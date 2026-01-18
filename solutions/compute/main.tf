# Compute Infrastructure - SOLUTION
# =================================
# This creates EC2 instance with SSH access.

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

  # Uncomment this after creating the backend!
  # backend "s3" {
  #   bucket         = "terraform-challenge-tfstate-dev"
  #   key            = "compute/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-challenge-tflock-dev"
  #   encrypt        = true
  #
  #   # LocalStack endpoints (remove for real AWS)
  #   endpoints = {
  #     s3       = "http://localhost:4566"
  #     dynamodb = "http://localhost:4566"
  #   }
  #   skip_credentials_validation = true
  #   skip_metadata_api_check     = true
  # }
}

provider "aws" {
  region = var.aws_region

  # LocalStack configuration (comment out for real AWS)
  access_key = "test"
  secret_key = "test"

  endpoints {
    s3       = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
    iam      = "http://localhost:4566"
    ec2      = "http://localhost:4566"
    sts      = "http://localhost:4566"
  }

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  s3_use_path_style = true
}
