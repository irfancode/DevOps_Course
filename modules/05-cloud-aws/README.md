# Module 5: Cloud Fundamentals (AWS)

## Learning Objectives

By the end of this module, you will:
- ✅ Understand cloud computing concepts
- ✅ Navigate AWS console
- ✅ Deploy EC2 instances
- ✅ Use S3 for storage
- ✅ Configure networking basics
- ✅ Set up basic security

## What is Cloud Computing?

Cloud computing is **on-demand availability of computing resources** (servers, storage, databases) delivered over the internet.

### Cloud vs On-Premises

| Aspect | On-Premises | Cloud |
|--------|-------------|-------|
| Initial Cost | High | Low |
| Scaling | Slow | Instant |
| Maintenance | In-house | Provider |
| Pay | CapEx | OpEx |
| Capacity | Fixed | Elastic |

## AWS Services Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     AWS Services                            │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │  Compute    │  │   Storage   │  │  Database   │        │
│  │  ────────  │  │  ────────  │  │  ────────  │        │
│  │  EC2       │  │  S3        │  │  RDS       │        │
│  │  Lambda    │  │  EBS       │  │  DynamoDB  │        │
│  │  ECS/EKS   │  │  EFS       │  │  Aurora    │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │  Networking │  │  Security  │  │   DevOps   │        │
│  │  ────────  │  │  ────────  │  │  ────────  │        │
│  │  VPC       │  │  IAM       │  │  CodePipeline│        │
│  │  Route 53  │  │  KMS       │  │  CodeBuild │        │
│  │  CloudFront│  │  WAF      │  │  CodeDeploy │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
└─────────────────────────────────────────────────────────────┘
```

## Core AWS Services

### Amazon EC2 (Elastic Compute Cloud)

Virtual servers in the cloud.

```bash
# AWS CLI basics
aws ec2 describe-instances
aws ec2 run-instances --image-id ami-0c55b159cbfafe1f0 --count 1 --instance-type t2.micro
```

**Instance Types:**

| Type | Use Case |
|------|---------|
| t2.micro | Learning, testing |
| t3.medium | Small applications |
| m5.large | General purpose |
| c5.xlarge | Compute intensive |
| r5.large | Memory intensive |

### Amazon S3 (Simple Storage Service)

Object storage for files.

```bash
# S3 CLI commands
aws s3 mb s3://my-bucket-name          # Make bucket
aws s3 ls                               # List buckets
aws s3 cp file.txt s3://my-bucket/     # Upload
aws s3 sync ./folder s3://my-bucket/    # Sync folder
aws s3 rm s3://my-bucket/file.txt       # Delete
```

**Storage Classes:**

| Class | Use Case | Cost |
|-------|----------|------|
| S3 Standard | Frequently accessed | Higher |
| S3 IA | Infrequently accessed | Lower |
| S3 Glacier | Archival | Lowest |
| S3 Intelligent | Auto-tiering | Variable |

### Amazon RDS (Relational Database Service)

Managed databases.

| Engine | Description |
|--------|-------------|
| PostgreSQL | Open-source, robust |
| MySQL | Popular web app DB |
| MariaDB | MySQL fork |
| Oracle | Enterprise |
| SQL Server | Microsoft |

### Amazon VPC (Virtual Private Cloud)

Virtual network for your resources.

```
┌──────────────────────────────────────────────────┐
│                    VPC                            │
│  ┌────────────────────────────────────────────┐  │
│  │           Public Subnet                     │  │
│  │  ┌────────────────────────────────────┐   │  │
│  │  │  EC2 Instance (with Public IP)     │   │  │
│  │  └────────────────────────────────────┘   │  │
│  └────────────────────────────────────────────┘  │
│                                                   │
│  ┌────────────────────────────────────────────┐  │
│  │           Private Subnet                    │  │
│  │  ┌────────────────────────────────────┐   │  │
│  │  │  EC2 Instance (no Public IP)      │   │  │
│  │  │  RDS Database                     │   │  │
│  │  └────────────────────────────────────┘   │  │
│  └────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────┘
```

### AWS IAM (Identity and Access Management)

Manage access to AWS services.

```bash
# Create user
aws iam create-user --user-name my-user

# Create access key
aws iam create-access-key --user-name my-user

# Attach policy
aws iam attach-user-policy --user-name my-user --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
```

## AWS CLI Setup

```bash
# Install AWS CLI
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

# Configure
aws configure
# AWS Access Key ID: YOUR_KEY
# AWS Secret Access Key: YOUR_SECRET
# Default region name: us-east-1
# Default output format: json
```

## Common AWS CLI Commands

```bash
# General
aws help
aws ec2 help
aws s3 help

# EC2
aws ec2 describe-vpcs
aws ec2 describe-instances
aws ec2 create-security-group --group-name my-sg --description "My security group"

# S3
aws s3 ls
aws s3 mb s3://unique-bucket-name
aws s3 cp localfile.txt s3://bucket/
aws s3 sync ./dir s3://bucket/

# IAM
aws iam list-users
aws iam get-user
```

## Security Best Practices

1. **Never use root account** for daily tasks
2. **Enable MFA** on all accounts
3. **Use IAM roles** instead of access keys
4. **Follow least privilege** principle
5. **Enable CloudTrail** for audit logging
6. **Use security groups** as firewalls

## AWS Free Tier

| Service | Free Tier Allowance |
|---------|-------------------|
| EC2 | 750 hrs/month (t2.micro) |
| S3 | 5 GB standard storage |
| RDS | 750 hrs/month (db.t2.micro) |
| Lambda | 1M requests/month |
| CloudWatch | 10 metrics/month |

## Getting Started Checklist

- [ ] Create AWS Account
- [ ] Enable MFA on root account
- [ ] Create IAM admin user
- [ ] Install AWS CLI
- [ ] Configure AWS CLI
- [ ] Launch first EC2 instance
- [ ] Create first S3 bucket
- [ ] Explore AWS Console

## Next Steps

➡️ **[Lab: Deploy to AWS](./labs/lab-05-deploy-aws.md)** - Practice deploying to the cloud

---

**← [Back to Module 4](../04-cicd-pipelines/README.md)** | **[Module 6: Kubernetes →](../06-kubernetes/README.md)**