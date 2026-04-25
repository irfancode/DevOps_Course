# Lab 5: Deploy to AWS ☁️

Time: 60 minutes | Difficulty: Intermediate

## Prerequisites

- AWS Account (free tier)
- AWS CLI installed and configured

## Part 1: Launch an EC2 Instance

### Create Key Pair

```bash
# Create key pair
aws ec2 create-key-pair \
  --key-name my-devops-key \
  --query 'KeyMaterial' \
  --output text > ~/my-devops-key.pem

# Secure the key
chmod 400 ~/my-devops-key.pem
```

### Create Security Group

```bash
aws ec2 create-security-group \
  --group-name my-devops-sg \
  --description "My DevOps Security Group" \
  --tag-specifications 'ResourceType=security-group,Tags=[{Key=Name,Value=my-devops-sg}]'
```

### Add Rules

```bash
SG_ID=$(aws ec2 describe-security-groups \
  --group-names my-devops-sg \
  --query 'SecurityGroups[0].GroupId' \
  --output text)

# SSH access
aws ec2 authorize-security-group-ingress \
  --group-id $SG_ID \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0

# HTTP
aws ec2 authorize-security-group-ingress \
  --group-id $SG_ID \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0

# Custom port (Node app)
aws ec2 authorize-security-group-ingress \
  --group-id $SG_ID \
  --protocol tcp \
  --port 3000 \
  --cidr 0.0.0.0/0
```

### Launch Instance

```bash
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \
  --count 1 \
  --instance-type t2.micro \
  --key-name my-devops-key \
  --security-group-ids $SG_ID \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=my-devops-server}]'
```

### Get Public IP

```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=my-devops-server" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text
```

---

## Part 2: Connect and Setup

```bash
# Get the IP
INSTANCE_IP=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=my-devops-server" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)

# Connect via SSH
ssh -i ~/my-devops-key.pem ec2-user@$INSTANCE_IP

# Inside the instance, install Node.js:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install 18

# Install git and build tools
sudo yum install git -y
```

---

## Part 3: Deploy Application

On your local machine:

```bash
# Create deployment package
mkdir ~/app-deploy
cd ~/app-deploy

cat > index.js << 'EOF'
const http = require('http');
const PORT = 3000;

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/html' });
  res.end(`
    <html>
      <body>
        <h1>☁️ Hello from AWS!</h1>
        <p>Running on EC2 Instance</p>
        <p>Time: ${new Date().toISOString()}</p>
      </body>
    </html>
  `);
});

server.listen(PORT, () => {
  console.log('Server running on port ' + PORT);
});
EOF

cat > package.json << 'EOF'
{
  "name": "aws-app",
  "version": "1.0.0",
  "scripts": {
    "start": "node index.js"
  }
}
EOF

# Upload to S3
aws s3 mb s3://my-app-deploy-$(date +%Y%m%d)
aws s3 sync ./ s3://my-app-deploy-$(date +%Y%m%d)/app/
```

On the EC2 instance:

```bash
# Create and enter app directory
mkdir -p ~/app
cd ~/app

# Download from S3
aws s3 sync s3://my-app-deploy-YYYYMMDD/app/ ./

# Install dependencies (none needed for this simple app)

# Start the app
node index.js &

# Test
curl http://localhost:3000
```

---

## Part 4: Create S3 Static Website

```bash
# Create bucket for static website
aws s3 mb s3://my-static-site-$(date +%Y%m%d)

# Enable website hosting
aws s3 website s3://my-static-site-$(date +%Y%m%d) \
  --index-document index.html \
  --error-document error.html

# Make files public
aws s3api put-bucket-acl \
  --bucket my-static-site-$(date +%Y%m%d) \
  --acl public-read

# Upload website files
echo "<html><body><h1>Hello AWS!</h1></body></html>" > index.html
aws s3 cp index.html s3://my-static-site-$(date +%Y%m%d)/

# Set public read on objects
aws s3api put-object-acl \
  --bucket my-static-site-$(date +%Y%m%d) \
  --key index.html \
  --acl public-read

# Get website URL
aws s3 website s3://my-static-site-$(date +%Y%m%d) --query '[WebsiteEndpoint]' --output text
```

---

## Part 5: Create IAM Role for EC2

```bash
# Create trust policy
cat > trust-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "ec2.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

# Create role
aws iam create-role \
  --role-name my-ec2-role \
  --assume-role-policy-document file://trust-policy.json

# Attach S3 read-only policy
aws iam attach-role-policy \
  --role-name my-ec2-role \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

# Create instance profile
aws iam create-instance-profile --instance-profile-name my-ec2-profile
aws iam add-role-to-instance-profile \
  --role-name my-ec2-role \
  --instance-profile-name my-ec2-profile

# Associate with instance (use your instance ID)
aws ec2 associate-iam-instance-profile \
  --instance-id i-xxxxxxxxxxxxx \
  --iam-instance-profile Name=my-ec2-profile
```

---

## Cleanup

```bash
# Terminate instance
aws ec2 terminate-instances \
  --instance-ids $(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=my-devops-server" \
    --query 'Reservations[0].Instances[0].InstanceId' \
    --output text)

# Delete security group (wait for instance termination first)
aws ec2 delete-security-group --group-name my-devops-sg

# Delete S3 buckets
aws s3 rb s3://my-app-deploy-YYYYMMDD --force
aws s3 rb s3://my-static-site-YYYYMMDD --force

# Delete key pair
aws ec2 delete-key-pair --key-name my-devops-key

# Delete IAM resources
aws iam remove-role-from-instance-profile \
  --role-name my-ec2-role \
  --instance-profile-name my-ec2-profile
aws iam delete-instance-profile --instance-profile-name my-ec2-profile
aws iam detach-role-policy \
  --role-name my-ec2-role \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
aws iam delete-role --role-name my-ec2-role

# Clean local files
rm ~/my-devops-key.pem
rm -rf ~/app-deploy
```

---

## What You Learned

- ✅ Launching EC2 instances
- ✅ Managing security groups
- ✅ SSH access to instances
- ✅ Deploying apps to EC2
- ✅ S3 bucket creation
- ✅ Static website hosting
- ✅ IAM roles for EC2

---

**Lab Complete! 🎉**

Next: [Module 6: Kubernetes](../06-kubernetes/README.md)