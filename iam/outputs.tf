# IAM Outputs - STARTER FILE
# ===========================
# TODO: Add outputs for the created IAM resources!
#
# IMPORTANT SECURITY NOTE:
#   - The secret access key is shown only ONCE after creation
#   - Save it immediately in a secure location!
#   - If lost, you must delete and recreate the keys
#
# How to use the keys:
#
# Option 1: Environment Variables
#   export AWS_ACCESS_KEY_ID="<access_key_id>"
#   export AWS_SECRET_ACCESS_KEY="<secret_access_key>"
#
# Option 2: AWS CLI Profile
#   aws configure --profile terraform-deployer
#   # Enter access key ID when prompted
#   # Enter secret access key when prompted
#
# Option 3: Terraform Variables
#   # In your provider block:
#   provider "aws" {
#     access_key = var.aws_access_key
#     secret_key = var.aws_secret_key
#   }
#   # WARNING: Don't hardcode keys in your code!

# =============================================================================
# TODO: Uncomment these outputs after completing users.tf
# =============================================================================

# Output the IAM user name
output "iam_user_name" {
  description = "Name of the IAM user"
  value       = aws_iam_user.terraform_deployer.name
}

# Output the IAM user ARN
output "iam_user_arn" {
  description = "ARN of the IAM user"
  value       = aws_iam_user.terraform_deployer.arn
}

# Output the Access Key ID
output "access_key_id" {
  description = "Access Key ID for the IAM user"
  value       = aws_iam_access_key.terraform_deployer.id
}

# Output the Secret Access Key
# IMPORTANT: This is marked as sensitive so it won't show in logs
output "secret_access_key" {
  description = "Secret Access Key for the IAM user (KEEP THIS SECRET!)"
  value       = aws_iam_access_key.terraform_deployer.secret
  sensitive   = true  # This hides the value in output
}

# =============================================================================
# How to View the Secret Access Key
# =============================================================================
# Since the secret is marked as sensitive, use this command:
#
#   terraform output -raw secret_access_key
#
# This will display the actual value.
# IMMEDIATELY copy it to a secure location (password manager, etc.)
