# DynamoDB Table for State Locking - STARTER FILE
# ================================================
# TODO: Create a DynamoDB table for Terraform state locking!
#
# What is state locking?
#   - Prevents two people from running terraform apply at the same time
#   - Like a "lock" on a door - only one person can enter at a time
#   - Protects your state file from corruption
#
# How it works:
#   1. You run "terraform apply"
#   2. Terraform creates a lock in DynamoDB
#   3. Someone else tries to run "terraform apply"
#   4. They see "Error: state locked" and have to wait
#   5. When you're done, the lock is released
#   6. Now they can run their command
#
# DynamoDB basics:
#   - DynamoDB is a NoSQL database service
#   - Perfect for simple key-value storage (like locks!)
#   - The "hash key" is like a primary key in a database
#
# Requirements:
#   1. Create a DynamoDB table
#   2. Use "LockID" as the hash key (required by Terraform)
#   3. Use pay-per-request billing (simplest option)
#
# See README.md for detailed explanations!

# =============================================================================
# STEP 1: Create the DynamoDB Table
# =============================================================================
# TODO: Uncomment and create the DynamoDB table for state locking
#
# The table name comes from local.table_name (defined in main.tf)
#
# resource "aws_dynamodb_table" "terraform_lock" {
#   name         = local.table_name
#   billing_mode = "PAY_PER_REQUEST"  # No need to set capacity, pay only for what you use
#
#   # IMPORTANT: The hash key MUST be named "LockID"
#   # This is required by Terraform's S3 backend
#   hash_key = "LockID"
#
#   # Define the LockID attribute
#   # Type "S" means String
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
#
#   tags = {
#     Name        = "Terraform State Lock Table"
#     Purpose     = "terraform-lock"
#     Environment = var.environment
#   }
# }
