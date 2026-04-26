# Networking Basics

## Basic Commands

```bash
ping host                    # Test connectivity
curl http://url            # Fetch URL
wget url                   # Download file
ftp host                  # FTP client
```

## Network Configuration

```bash
ifconfig / ip addr         # Show IP addresses
ip link show             # Show network interfaces
ip route show           # Show routing table
```

## DNS

```bash
nslookup domain           # DNS lookup
dig domain             # Detailed DNS lookup
host domain             # Simple DNS lookup
```

## SSH

```bash
ssh user@host           # Connect to remote host
scp file user@host:/path   # Secure copy
sftp user@host         # Secure FTP
```

## Ports

```bash
netstat -tulpn          # Listening ports
ss -tulpn              # Modern socket info
lsof -i                # Open files/network
```

## Firewall (ufw)

```bash
sudo ufw status         # Check status
sudo ufw allow 80      # Allow port
sudo ufw deny port     # Block port
sudo ufw enable       # Enable firewall
```

## Curl Options

```bash
curl -O file.txt       # Download
curl -I url           # Headers only
curl -d data url      # POST data
curl -H "Header: value" url  # Custom header
```

---

**Next: [Lab Exercises](./labs/lab-02-linux-scavenger.md)**