# IAM Users - SOLUTION
# ====================

# Create an IAM user for Terraform operations
resource "aws_iam_user" "terraform" {
  name = "${var.project_name}-terraform-user"
  path = "/system/"

  tags = {
    Name        = "${var.project_name}-terraform-user"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Terraform Automation"
  }
}

# Create access keys for the user
# These are the credentials used to authenticate with AWS
resource "aws_iam_access_key" "terraform" {
  user = aws_iam_user.terraform.name
}

# Attach the policy to the user
resource "aws_iam_user_policy_attachment" "terraform_state_access" {
  user       = aws_iam_user.terraform.name
  policy_arn = aws_iam_policy.terraform_state_access.arn
}

resource "aws_iam_user_policy_attachment" "terraform_ec2_access" {
  user       = aws_iam_user.terraform.name
  policy_arn = aws_iam_policy.terraform_ec2_access.arn
}
