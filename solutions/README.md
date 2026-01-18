# Solutions - Terraform Remote State Challenge

This folder contains complete working solutions for the challenge.

## How to Use These Solutions

**DO NOT copy these files directly!** Use them as reference if you get stuck.

### Recommended Approach

1. **Try First**: Attempt each step on your own
2. **Check Progress**: Run `python run.py` to see what's missing
3. **Reference Solutions**: If stuck, look at the specific file you need help with
4. **Understand, Don't Copy**: Read the code, understand it, then write your own version

## Solution Files

### Backend Module (`solutions/backend/`)
- `main.tf` - Provider configuration for LocalStack/AWS
- `variables.tf` - Variable definitions
- `s3.tf` - S3 bucket with versioning and encryption
- `dynamodb.tf` - DynamoDB table for state locking
- `outputs.tf` - Outputs including backend configuration

### IAM Module (`solutions/iam/`)
- `main.tf` - Provider configuration
- `variables.tf` - Variable definitions
- `users.tf` - IAM user and access key creation
- `policies.tf` - IAM policies for S3, DynamoDB, and EC2
- `outputs.tf` - Access key outputs

### Compute Module (`solutions/compute/`)
- `main.tf` - Provider configuration with S3 backend
- `variables.tf` - Variable definitions
- `ssh-key.tf` - TLS private key and AWS key pair
- `security.tf` - Security group for SSH access
- `ec2.tf` - EC2 instance configuration
- `outputs.tf` - Instance details and SSH command

## Testing Solutions

To test the solutions with LocalStack:

```bash
# 1. Start LocalStack
docker-compose up -d

# 2. Test backend module
cd solutions/backend
terraform init
terraform plan
terraform apply -auto-approve

# 3. Test IAM module
cd ../iam
terraform init
terraform plan
terraform apply -auto-approve

# 4. Test compute module
cd ../compute
terraform init
terraform plan
terraform apply -auto-approve
```

## Key Learning Points

After completing this challenge, you should understand:

1. **Remote State**: Why it matters and how S3 backend works
2. **State Locking**: How DynamoDB prevents corruption
3. **IAM**: Users, policies, and access keys
4. **SSH Keys**: How Terraform generates and manages keys
5. **Security Groups**: Network-level access control
6. **EC2**: Launching instances with Terraform
