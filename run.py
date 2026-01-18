#!/usr/bin/env python3
"""
Terraform Remote State Challenge - Progress Checker
====================================================

Run this script to check your progress on the challenge.
It validates your Terraform configurations against the requirements.

Usage:
    python run.py           # Check all modules
    python run.py backend   # Check only backend module
    python run.py iam       # Check only IAM module
    python run.py compute   # Check only compute module
"""

import os
import sys
import re
import json
import subprocess
from pathlib import Path

# ANSI color codes for terminal output
class Colors:
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    BOLD = '\033[1m'
    END = '\033[0m'

def print_header(text):
    print(f"\n{Colors.BOLD}{Colors.BLUE}{'='*60}{Colors.END}")
    print(f"{Colors.BOLD}{Colors.BLUE}{text.center(60)}{Colors.END}")
    print(f"{Colors.BOLD}{Colors.BLUE}{'='*60}{Colors.END}\n")

def print_section(text):
    print(f"\n{Colors.CYAN}{'-'*50}{Colors.END}")
    print(f"{Colors.CYAN}{text}{Colors.END}")
    print(f"{Colors.CYAN}{'-'*50}{Colors.END}")

def print_pass(text):
    print(f"  {Colors.GREEN}[PASS]{Colors.END} {text}")

def print_fail(text):
    print(f"  {Colors.RED}[FAIL]{Colors.END} {text}")

def print_warn(text):
    print(f"  {Colors.YELLOW}[WARN]{Colors.END} {text}")

def print_info(text):
    print(f"  {Colors.BLUE}[INFO]{Colors.END} {text}")

def file_exists(path):
    """Check if a file exists."""
    return Path(path).exists()

def file_contains(path, pattern, is_regex=False):
    """Check if a file contains a pattern."""
    if not file_exists(path):
        return False

    try:
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()

        if is_regex:
            return bool(re.search(pattern, content, re.MULTILINE | re.DOTALL))
        else:
            return pattern in content
    except Exception:
        return False

def is_commented_out(path, pattern):
    """Check if a pattern appears only in comments."""
    if not file_exists(path):
        return True

    try:
        with open(path, 'r', encoding='utf-8') as f:
            lines = f.readlines()

        for line in lines:
            stripped = line.strip()
            # Skip empty lines and comments
            if stripped.startswith('#') or not stripped:
                continue
            if pattern in line:
                return False
        return True
    except Exception:
        return True

def check_terraform_valid(directory):
    """Check if terraform validate passes."""
    try:
        # First run terraform init
        result = subprocess.run(
            ['terraform', 'init', '-backend=false'],
            cwd=directory,
            capture_output=True,
            text=True,
            timeout=60
        )
        if result.returncode != 0:
            return False, f"terraform init failed: {result.stderr}"

        # Then run terraform validate
        result = subprocess.run(
            ['terraform', 'validate'],
            cwd=directory,
            capture_output=True,
            text=True,
            timeout=30
        )
        if result.returncode != 0:
            return False, f"terraform validate failed: {result.stderr}"

        return True, "Configuration is valid"
    except FileNotFoundError:
        return False, "Terraform not found. Please install Terraform."
    except subprocess.TimeoutExpired:
        return False, "Terraform command timed out"
    except Exception as e:
        return False, str(e)

def check_backend_module():
    """Check the backend module configuration."""
    print_section("Checking Backend Module")

    base_path = Path("backend")
    passed = 0
    failed = 0

    # Check required files exist
    required_files = ['main.tf', 'variables.tf', 's3.tf', 'dynamodb.tf', 'outputs.tf']
    for f in required_files:
        if file_exists(base_path / f):
            print_pass(f"File {f} exists")
            passed += 1
        else:
            print_fail(f"File {f} is missing")
            failed += 1

    # Check S3 bucket configuration
    s3_path = base_path / "s3.tf"

    s3_checks = [
        ('aws_s3_bucket', 'S3 bucket resource defined'),
        ('aws_s3_bucket_versioning', 'Versioning enabled'),
        ('aws_s3_bucket_server_side_encryption_configuration', 'Encryption configured'),
        ('aws_s3_bucket_public_access_block', 'Public access blocked'),
    ]

    for pattern, description in s3_checks:
        if file_contains(s3_path, pattern) and not is_commented_out(s3_path, pattern):
            print_pass(description)
            passed += 1
        else:
            print_fail(f"{description} - uncomment/add {pattern}")
            failed += 1

    # Check DynamoDB table configuration
    dynamodb_path = base_path / "dynamodb.tf"

    if file_contains(dynamodb_path, 'aws_dynamodb_table') and not is_commented_out(dynamodb_path, 'aws_dynamodb_table'):
        print_pass("DynamoDB table resource defined")
        passed += 1
    else:
        print_fail("DynamoDB table resource missing")
        failed += 1

    if file_contains(dynamodb_path, 'LockID'):
        print_pass("LockID hash key configured")
        passed += 1
    else:
        print_fail("LockID hash key missing (must be exactly 'LockID')")
        failed += 1

    # Check outputs
    outputs_path = base_path / "outputs.tf"

    output_checks = [
        ('s3_bucket_name', 'S3 bucket name output'),
        ('dynamodb_table_name', 'DynamoDB table name output'),
    ]

    for pattern, description in output_checks:
        if file_contains(outputs_path, f'output "{pattern}"') and not is_commented_out(outputs_path, f'output "{pattern}"'):
            print_pass(description)
            passed += 1
        else:
            print_fail(f"{description} - uncomment output block")
            failed += 1

    # Validate Terraform configuration
    if all(file_exists(base_path / f) for f in required_files):
        valid, msg = check_terraform_valid(base_path)
        if valid:
            print_pass(f"Terraform validation: {msg}")
            passed += 1
        else:
            print_fail(f"Terraform validation: {msg}")
            failed += 1

    return passed, failed

def check_iam_module():
    """Check the IAM module configuration."""
    print_section("Checking IAM Module")

    base_path = Path("iam")
    passed = 0
    failed = 0

    # Check required files exist
    required_files = ['main.tf', 'variables.tf', 'users.tf', 'policies.tf', 'outputs.tf']
    for f in required_files:
        if file_exists(base_path / f):
            print_pass(f"File {f} exists")
            passed += 1
        else:
            print_fail(f"File {f} is missing")
            failed += 1

    # Check IAM user configuration
    users_path = base_path / "users.tf"

    user_checks = [
        ('aws_iam_user', 'IAM user resource defined'),
        ('aws_iam_access_key', 'Access key resource defined'),
        ('aws_iam_user_policy_attachment', 'Policy attachment defined'),
    ]

    for pattern, description in user_checks:
        if file_contains(users_path, pattern) and not is_commented_out(users_path, pattern):
            print_pass(description)
            passed += 1
        else:
            print_fail(f"{description} - uncomment/add {pattern}")
            failed += 1

    # Check IAM policy configuration
    policies_path = base_path / "policies.tf"

    if file_contains(policies_path, 'aws_iam_policy') and not is_commented_out(policies_path, 'aws_iam_policy'):
        print_pass("IAM policy resource defined")
        passed += 1
    else:
        print_fail("IAM policy resource missing")
        failed += 1

    # Check for S3 and DynamoDB permissions
    if file_contains(policies_path, 's3:'):
        print_pass("S3 permissions configured")
        passed += 1
    else:
        print_fail("S3 permissions missing in policy")
        failed += 1

    if file_contains(policies_path, 'dynamodb:'):
        print_pass("DynamoDB permissions configured")
        passed += 1
    else:
        print_fail("DynamoDB permissions missing in policy")
        failed += 1

    # Check outputs
    outputs_path = base_path / "outputs.tf"

    output_checks = [
        ('access_key_id', 'Access Key ID output'),
        ('secret_access_key', 'Secret Access Key output'),
    ]

    for pattern, description in output_checks:
        if file_contains(outputs_path, f'output "{pattern}"') and not is_commented_out(outputs_path, f'output "{pattern}"'):
            print_pass(description)
            passed += 1
        else:
            print_fail(f"{description} - uncomment output block")
            failed += 1

    # Check sensitive flag on secret key
    if file_contains(outputs_path, 'sensitive'):
        print_pass("Sensitive flag on secret key")
        passed += 1
    else:
        print_warn("Consider adding sensitive = true to secret_access_key output")

    # Validate Terraform configuration
    if all(file_exists(base_path / f) for f in required_files):
        valid, msg = check_terraform_valid(base_path)
        if valid:
            print_pass(f"Terraform validation: {msg}")
            passed += 1
        else:
            print_fail(f"Terraform validation: {msg}")
            failed += 1

    return passed, failed

def check_compute_module():
    """Check the compute module configuration."""
    print_section("Checking Compute Module")

    base_path = Path("compute")
    passed = 0
    failed = 0

    # Check required files exist
    required_files = ['main.tf', 'variables.tf', 'ssh-key.tf', 'security.tf', 'ec2.tf', 'outputs.tf']
    for f in required_files:
        if file_exists(base_path / f):
            print_pass(f"File {f} exists")
            passed += 1
        else:
            print_fail(f"File {f} is missing")
            failed += 1

    # Check SSH key configuration
    ssh_path = base_path / "ssh-key.tf"

    ssh_checks = [
        ('tls_private_key', 'TLS private key resource defined'),
        ('aws_key_pair', 'AWS key pair resource defined'),
        ('local_file', 'Local file for private key defined'),
    ]

    for pattern, description in ssh_checks:
        if file_contains(ssh_path, pattern) and not is_commented_out(ssh_path, pattern):
            print_pass(description)
            passed += 1
        else:
            print_fail(f"{description} - uncomment/add {pattern}")
            failed += 1

    # Check security group configuration
    security_path = base_path / "security.tf"

    if file_contains(security_path, 'aws_security_group') and not is_commented_out(security_path, 'aws_security_group'):
        print_pass("Security group resource defined")
        passed += 1
    else:
        print_fail("Security group resource missing")
        failed += 1

    # Check for SSH port 22
    if file_contains(security_path, '22'):
        print_pass("SSH port 22 configured")
        passed += 1
    else:
        print_fail("SSH port 22 not found in security group")
        failed += 1

    # Check EC2 instance configuration
    ec2_path = base_path / "ec2.tf"

    ec2_checks = [
        ('aws_instance', 'EC2 instance resource defined'),
        ('data "aws_ami"', 'AMI data source defined'),
    ]

    for pattern, description in ec2_checks:
        if file_contains(ec2_path, pattern) and not is_commented_out(ec2_path, pattern):
            print_pass(description)
            passed += 1
        else:
            print_fail(f"{description} - uncomment/add the resource")
            failed += 1

    # Check EC2 uses key pair
    if file_contains(ec2_path, 'key_name'):
        print_pass("EC2 instance uses key pair")
        passed += 1
    else:
        print_fail("EC2 instance missing key_name attribute")
        failed += 1

    # Check EC2 uses security group
    if file_contains(ec2_path, 'vpc_security_group_ids') or file_contains(ec2_path, 'security_groups'):
        print_pass("EC2 instance uses security group")
        passed += 1
    else:
        print_fail("EC2 instance missing security group configuration")
        failed += 1

    # Check outputs
    outputs_path = base_path / "outputs.tf"

    output_checks = [
        ('instance_id', 'Instance ID output'),
        ('instance_public_ip', 'Public IP output'),
        ('ssh_command', 'SSH command output'),
    ]

    for pattern, description in output_checks:
        if file_contains(outputs_path, f'output "{pattern}"') and not is_commented_out(outputs_path, f'output "{pattern}"'):
            print_pass(description)
            passed += 1
        else:
            print_fail(f"{description} - uncomment output block")
            failed += 1

    # Validate Terraform configuration
    if all(file_exists(base_path / f) for f in required_files):
        valid, msg = check_terraform_valid(base_path)
        if valid:
            print_pass(f"Terraform validation: {msg}")
            passed += 1
        else:
            print_fail(f"Terraform validation: {msg}")
            failed += 1

    return passed, failed

def check_backend_config():
    """Check if compute module has S3 backend configured."""
    print_section("Checking Remote State Configuration")

    passed = 0
    failed = 0

    main_path = Path("compute/main.tf")

    if file_contains(main_path, 'backend "s3"'):
        # Check if it's not commented out
        if is_commented_out(main_path, 'backend "s3"'):
            print_warn("S3 backend is defined but commented out (OK for LocalStack testing)")
        else:
            print_pass("S3 backend configured in compute module")
            passed += 1

            # Check required backend attributes
            backend_attrs = ['bucket', 'key', 'region', 'dynamodb_table', 'encrypt']
            for attr in backend_attrs:
                if file_contains(main_path, attr):
                    print_pass(f"Backend {attr} configured")
                    passed += 1
                else:
                    print_fail(f"Backend {attr} missing")
                    failed += 1
    else:
        print_info("S3 backend not configured yet (optional for LocalStack testing)")

    return passed, failed

def print_summary(total_passed, total_failed):
    """Print the final summary."""
    print_header("CHALLENGE PROGRESS SUMMARY")

    total = total_passed + total_failed
    if total == 0:
        print_info("No checks performed")
        return

    percentage = (total_passed / total) * 100

    print(f"\n  Total Checks: {total}")
    print(f"  {Colors.GREEN}Passed: {total_passed}{Colors.END}")
    print(f"  {Colors.RED}Failed: {total_failed}{Colors.END}")
    print(f"\n  Progress: {percentage:.1f}%")

    # Progress bar
    bar_width = 40
    filled = int(bar_width * percentage / 100)
    bar = '=' * filled + '-' * (bar_width - filled)
    print(f"\n  [{bar}]")

    if percentage == 100:
        print(f"\n  {Colors.GREEN}{Colors.BOLD}Congratulations! All checks passed!{Colors.END}")
        print(f"  {Colors.GREEN}Your Terraform configuration is complete.{Colors.END}")
        print(f"\n  Next steps:")
        print(f"  1. Test with LocalStack: docker-compose up -d")
        print(f"  2. Deploy to real AWS (if ready)")
        print(f"  3. Push to GitHub to trigger grading")
    elif percentage >= 75:
        print(f"\n  {Colors.YELLOW}Almost there! Just a few more items to complete.{Colors.END}")
    elif percentage >= 50:
        print(f"\n  {Colors.YELLOW}Good progress! Keep going!{Colors.END}")
    else:
        print(f"\n  {Colors.BLUE}Getting started. Check the README for guidance.{Colors.END}")

def main():
    """Main entry point."""
    print_header("Terraform Remote State Challenge")
    print_info("Checking your progress...")

    # Change to the challenge directory if we're in a subdirectory
    if Path("run.py").exists():
        pass  # Already in the right directory
    elif Path("../run.py").exists():
        os.chdir("..")

    # Parse command line arguments
    modules_to_check = sys.argv[1:] if len(sys.argv) > 1 else ['backend', 'iam', 'compute']

    total_passed = 0
    total_failed = 0

    if 'backend' in modules_to_check:
        passed, failed = check_backend_module()
        total_passed += passed
        total_failed += failed

    if 'iam' in modules_to_check:
        passed, failed = check_iam_module()
        total_passed += passed
        total_failed += failed

    if 'compute' in modules_to_check:
        passed, failed = check_compute_module()
        total_passed += passed
        total_failed += failed

        # Also check backend configuration
        passed, failed = check_backend_config()
        total_passed += passed
        total_failed += failed

    print_summary(total_passed, total_failed)

    # Return exit code based on results
    return 0 if total_failed == 0 else 1

if __name__ == "__main__":
    sys.exit(main())
