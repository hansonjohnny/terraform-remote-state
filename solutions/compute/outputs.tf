# Compute Outputs - SOLUTION
# ==========================

# EC2 Instance Outputs
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.web_server.private_ip
}

# SSH Key Outputs
output "key_pair_name" {
  description = "Name of the SSH key pair"
  value       = aws_key_pair.deployer.key_name
}

output "private_key_file" {
  description = "Path to the private key file"
  value       = local_file.private_key.filename
}

# Security Group Output
output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.ssh_access.id
}

# SSH Connection Command - The most useful output!
output "ssh_command" {
  description = "Command to SSH into the EC2 instance"
  value       = "ssh -i ${local_file.private_key.filename} ec2-user@${aws_instance.web_server.public_ip}"
}

output "connection_instructions" {
  description = "Instructions for connecting to the instance"
  value       = <<-EOT

    ============================================================
    EC2 Instance Created Successfully!
    ============================================================

    Instance ID: ${aws_instance.web_server.id}
    Public IP:   ${aws_instance.web_server.public_ip}

    To connect via SSH:
    1. Make sure the key file has correct permissions:
       chmod 400 ${local_file.private_key.filename}

    2. Connect with:
       ssh -i ${local_file.private_key.filename} ec2-user@${aws_instance.web_server.public_ip}

    Or use the ssh_command output:
       $(terraform output -raw ssh_command)

    First time connecting? Type "yes" when prompted about fingerprint.
    ============================================================
  EOT
}
