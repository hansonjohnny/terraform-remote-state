# IAM Users and Access Keys - STARTER FILE
# ==========================================
# TODO: Create IAM users and access keys for Terraform!
#
# What is an IAM User?
#   - An identity that represents a person or application
#   - Has credentials (username/password or access keys)
#   - Can be given permissions via policies
#
# What are Access Keys?
#   - Like a username/password for programmatic access
#   - Consists of:
#     * Access Key ID (like a username) - starts with "AKIA..."
#     * Secret Access Key (like a password) - keep this SECRET!
#   - Used by: AWS CLI, Terraform, SDKs, etc.
#
# SECURITY WARNING:
#   - Never commit access keys to Git!
#   - Never share your secret access key!
#   - Rotate keys regularly!
#
# Requirements:
#   1. Create an IAM user named "terraform-deployer"
#   2. Create access keys for the user
#   3. Output the keys (we'll need them later)
#
# See README.md for detailed explanations!

# =============================================================================
# STEP 1: Create the IAM User
# =============================================================================
# TODO: Uncomment and create the IAM user
#
# resource "aws_iam_user" "terraform_deployer" {
#   name = "terraform-deployer"
#   path = "/system/"  # Organizational path (optional)
#
#   tags = {
#     Name        = "Terraform Deployer"
#     Purpose     = "terraform-automation"
#     Description = "User for running Terraform commands"
#   }
# }

# =============================================================================
# STEP 2: Create Access Keys
# =============================================================================
# TODO: Uncomment and create access keys for the user
#
# These keys allow programmatic access to AWS.
# You'll use these to configure AWS CLI or Terraform.
#
# resource "aws_iam_access_key" "terraform_deployer" {
#   user = aws_iam_user.terraform_deployer.name
# }

# =============================================================================
# STEP 3: Attach Policy to User
# =============================================================================
# TODO: Uncomment after creating the policy in policies.tf
#
# This connects the user to the policy, giving them permissions.
#
# resource "aws_iam_user_policy_attachment" "terraform_deployer" {
#   user       = aws_iam_user.terraform_deployer.name
#   policy_arn = aws_iam_policy.terraform_state_access.arn
# }
