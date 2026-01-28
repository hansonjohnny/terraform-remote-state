# Security Group - STARTER FILE
# ==============================
# TODO: Create a security group to allow SSH access!
#
# What is a Security Group?
#   - A virtual firewall for your EC2 instance
#   - Controls what traffic can come IN (ingress) and go OUT (egress)
#   - By default, BLOCKS all inbound traffic
#   - By default, ALLOWS all outbound traffic
#
# Security Group Rules:
#   - Ingress: Traffic coming INTO your instance
#   - Egress: Traffic going OUT from your instance
#   - Each rule specifies: protocol, port, source/destination
#
# For SSH:
#   - Port 22 (the standard SSH port)
#   - Protocol: TCP
#   - Source: Your IP address (most secure) or 0.0.0.0/0 (anywhere)
#
# SECURITY WARNING:
#   - Using 0.0.0.0/0 allows SSH from ANYWHERE (risky!)
#   - In production, restrict to specific IP addresses
#   - Consider using a bastion host for extra security
#
# Requirements:
#   1. Create a security group in the default VPC
#   2. Allow SSH (port 22) inbound
#   3. Allow all outbound traffic (for updates, etc.)
#
# See README.md for detailed explanations!

# =============================================================================
# STEP 1: Create the Security Group
# =============================================================================
# TODO: Uncomment and create the security group
#
resource "aws_security_group" "ssh_access" {
  name        = "${var.project_name}-${var.environment}-ssh"
  description = "Security group allowing SSH access"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-ssh"
    Environment = var.environment
  }
}

# =============================================================================
# STEP 2: Allow SSH Inbound (Ingress)
# =============================================================================
# TODO: Uncomment to allow SSH traffic
#
# This rule allows incoming SSH connections on port 22.
#
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.ssh_access.id

  description = "Allow SSH from anywhere"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22

  # WARNING: 0.0.0.0/0 allows SSH from anywhere!
  # For better security, replace with your IP: "YOUR.IP.ADDRESS.HERE/32"
  cidr_ipv4 = "0.0.0.0/0"

  tags = {
    Name = "Allow SSH"
  }
}

# =============================================================================
# STEP 3: Allow All Outbound (Egress)
# =============================================================================
# TODO: Uncomment to allow outbound traffic
#
# This allows the instance to connect out (for updates, etc.)
#
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.ssh_access.id

  description = "Allow all outbound traffic"
  ip_protocol = "-1"  # -1 means all protocols

  cidr_ipv4 = "0.0.0.0/0"  # Allow to anywhere

  tags = {
    Name = "Allow all outbound"
  }
}
