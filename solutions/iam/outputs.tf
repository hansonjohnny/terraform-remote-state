# IAM Outputs - SOLUTION
# ======================

output "iam_user_name" {
  description = "Name of the IAM user"
  value       = aws_iam_user.terraform.name
}

output "iam_user_arn" {
  description = "ARN of the IAM user"
  value       = aws_iam_user.terraform.arn
}

# Access Key ID (safe to display)
output "access_key_id" {
  description = "Access Key ID for the IAM user"
  value       = aws_iam_access_key.terraform.id
}

# Secret Access Key (SENSITIVE - handle with care!)
output "secret_access_key" {
  description = "Secret Access Key for the IAM user"
  value       = aws_iam_access_key.terraform.secret
  sensitive   = true
}

# Instructions for using the credentials
output "credentials_usage" {
  description = "How to use these credentials"
  value       = <<-EOT

    ============================================================
    AWS Credentials Created!
    ============================================================

    Access Key ID: ${aws_iam_access_key.terraform.id}

    To see the Secret Access Key, run:
      terraform output -raw secret_access_key

    Configure AWS CLI with these credentials:
      aws configure --profile terraform-challenge

    Or set environment variables:
      export AWS_ACCESS_KEY_ID=${aws_iam_access_key.terraform.id}
      export AWS_SECRET_ACCESS_KEY=$(terraform output -raw secret_access_key)

    IMPORTANT: Keep your secret key secure!
    ============================================================
  EOT
}
