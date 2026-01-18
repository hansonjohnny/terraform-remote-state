# DynamoDB Table for State Locking - SOLUTION
# ============================================

# The DynamoDB table prevents concurrent modifications
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${var.project_name}-tflock-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"  # No capacity planning needed
  hash_key     = "LockID"           # MUST be exactly "LockID"

  attribute {
    name = "LockID"
    type = "S"  # String type
  }

  tags = {
    Name        = "${var.project_name}-tflock"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Terraform State Locking"
  }
}
