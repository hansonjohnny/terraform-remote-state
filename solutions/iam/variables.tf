# IAM Variables - SOLUTION
# ========================

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "terraform-challenge"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# These should match your backend outputs
variable "state_bucket_arn" {
  description = "ARN of the S3 bucket for Terraform state"
  type        = string
  default     = "arn:aws:s3:::terraform-challenge-tfstate-dev"
}

variable "lock_table_arn" {
  description = "ARN of the DynamoDB table for state locking"
  type        = string
  default     = "arn:aws:dynamodb:us-east-1:000000000000:table/terraform-challenge-tflock-dev"
}
