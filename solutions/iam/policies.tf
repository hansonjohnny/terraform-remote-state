# IAM Policies - SOLUTION
# =======================

# Policy for Terraform state access (S3 + DynamoDB)
resource "aws_iam_policy" "terraform_state_access" {
  name        = "${var.project_name}-terraform-state-access"
  path        = "/"
  description = "Policy for Terraform to access remote state"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3StateAccess"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          var.state_bucket_arn,
          "${var.state_bucket_arn}/*"
        ]
      },
      {
        Sid    = "DynamoDBLockAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = var.lock_table_arn
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-terraform-state-access"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Policy for EC2 operations
resource "aws_iam_policy" "terraform_ec2_access" {
  name        = "${var.project_name}-terraform-ec2-access"
  path        = "/"
  description = "Policy for Terraform to manage EC2 resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EC2FullAccess"
        Effect = "Allow"
        Action = [
          "ec2:*"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:RequestedRegion" = var.aws_region
          }
        }
      },
      {
        Sid    = "EC2Describe"
        Effect = "Allow"
        Action = [
          "ec2:Describe*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-terraform-ec2-access"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
