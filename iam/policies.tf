# IAM Policies - STARTER FILE
# ============================
# TODO: Create IAM policies to control access!
#
# What is an IAM Policy?
#   - A JSON document that defines permissions
#   - Says what actions are allowed or denied
#   - Can be attached to users, groups, or roles
#
# Policy Structure:
#   {
#     "Version": "2012-10-17",        <- Always use this version
#     "Statement": [
#       {
#         "Effect": "Allow",          <- Allow or Deny
#         "Action": ["s3:GetObject"], <- What actions
#         "Resource": ["arn:..."]     <- On what resources
#       }
#     ]
#   }
#
# Best Practice: Least Privilege
#   - Only give permissions that are actually needed
#   - Don't use "Action": "*" (allows everything!)
#   - Be specific with Resource ARNs
#
# Requirements:
#   1. Create a policy for S3 state bucket access
#   2. Create a policy for DynamoDB lock table access
#   3. Combine them into one policy
#
# See README.md for detailed explanations!

# =============================================================================
# STEP 1: Create the Terraform State Access Policy
# =============================================================================
# TODO: Uncomment and create the IAM policy
#
# This policy allows:
#   - Reading and writing to the S3 state bucket
#   - Reading and writing locks in DynamoDB
#
resource "aws_iam_policy" "terraform_state_access" {
  name        = "TerraformStateAccess"
  description = "Policy for accessing Terraform state in S3 and DynamoDB lock table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # S3 Bucket Access
      {
        Sid    = "S3BucketAccess"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",      # List objects in bucket
          "s3:GetBucketLocation" # Get bucket region
        ]
        # NOTE: Replace with your actual bucket ARN from backend outputs
        # Or use a variable: var.state_bucket_arn
        Resource = "arn:aws:s3:::terraform-state-dev-89ad680a"
      },
      # S3 Object Access
      {
        Sid    = "S3ObjectAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",       # Read state file
          "s3:PutObject",       # Write state file
          "s3:DeleteObject"     # Delete old state versions
        ]
        # Allow access to all objects in the bucket
        Resource = "arn:aws:s3:::terraform-state-dev-89ad680a/*"
      },
      # DynamoDB Lock Table Access
      {
        Sid    = "DynamoDBLockAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",    # Read lock status
          "dynamodb:PutItem",    # Create lock
          "dynamodb:DeleteItem"  # Release lock
        ]
        # NOTE: Replace with your actual table ARN
        Resource = "arn:aws:dynamodb:us-east-1:575271900676:table/terraform-state-lock"
      }
    ]
  })

  tags = {
    Name    = "Terraform State Access Policy"
    Purpose = "terraform"
  }
}

# =============================================================================
# OPTIONAL: Additional Policies for EC2 Management
# =============================================================================
# TODO: Uncomment if you want the user to also manage EC2 instances
#
resource "aws_iam_policy" "ec2_management" {
  name        = "TerraformEC2Management"
  description = "Policy for managing EC2 instances with Terraform"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EC2FullAccess"
        Effect = "Allow"
        Action = [
          "ec2:*"  # Full EC2 access - restrict in production!
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach EC2 policy to user
resource "aws_iam_user_policy_attachment" "terraform_deployer_ec2" {
  user       = aws_iam_user.terraform_deployer.name
  policy_arn = aws_iam_policy.ec2_management.arn
}
