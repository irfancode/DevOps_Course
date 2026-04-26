# EC2 & Compute

## Launch Instance

```bash
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \
  --count 1 \
  --instance-type t2.micro \
  --key-name my-key \
  --security-group-ids sg-xxxxx \
  --subnet-id subnet-xxxxx
```

## Instance Types

| Family | Type | Use Case |
|--------|------|----------|
| General | t3, m5 | General purpose |
| Compute | c5, c6i | Compute intensive |
| Memory | r5, r6i | Memory intensive |
| GPU | g4, p3 | ML/Graphics |
| Storage | i3, d2 | High I/O |

## Key Pairs

```bash
aws ec2 create-key-pair --key-name my-key
aws ec2 delete-key-pair --key-name my-key
```

## Security Groups

```bash
aws ec2 create-security-group \
  --group-name my-sg \
  --description "My security group"

aws ec2 authorize-security-group-ingress \
  --group-id sg-xxxxx \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0
```

## Instance Management

```bash
aws ec2 describe-instances
aws ec2 start-instances --instance-ids i-xxxxx
aws ec2 stop-instances --instance-ids i-xxxxx
aws ec2 terminate-instances --instance-ids i-xxxxx
aws ec2 reboot-instances --instance-ids i-xxxxx
```

## Elastic IP

```bash
aws ec2 allocate-address
aws ec2 associate-address --instance-id i-xxxxx --allocation-id eipalloc-xxxxx
aws ec2 release-address --allocation-id eipalloc-xxxxx
```

## User Data (Bootstrap)

```bash
aws ec2 run-instances \
  --image-id ami-xxx \
  --instance-type t2.micro \
  --user-data "#!/bin/bash\nyum update -y\nyum install -y httpd"
```

---

**Next: [S3 & Storage](./s3.md)**