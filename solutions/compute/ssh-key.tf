# SSH Key Pair - SOLUTION
# =======================

# Generate a new RSA key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Register the public key with AWS
resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-key-${var.environment}"
  public_key = tls_private_key.ssh_key.public_key_openssh

  tags = {
    Name        = "${var.project_name}-key"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Save the private key to a local file
resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/private-key.pem"
  file_permission = "0400"  # Read-only for owner
}
