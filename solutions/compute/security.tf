# Security Group - SOLUTION
# =========================

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Security group for SSH access
resource "aws_security_group" "ssh_access" {
  name        = "${var.project_name}-ssh-${var.environment}"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  # SSH inbound rule
  ingress {
    description = "SSH from allowed CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-ssh-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
