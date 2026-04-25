# Module 2: Linux Essentials

## Learning Objectives

By the end of this module, you will:
- ✅ Navigate the Linux file system
- ✅ Manage files and directories
- ✅ Work with text files and editors
- ✅ Understand permissions and ownership
- ✅ Manage processes
- ✅ Use environment variables

## What is Linux?

Linux is an **open-source operating system** that powers:
- 98% of the world's servers
- All supercomputers
- Android phones
- Smart devices and IoT

### Linux Distribution Types

| Type | Distributions | Best For |
|------|---------------|----------|
| **Debian-based** | Ubuntu, Mint | Beginners, general use |
| **RHEL-based** | CentOS, Rocky, Fedora | Enterprise, servers |
| **Arch-based** | Arch, Manjaro | Custom, rolling release |
| **Specialized** | Kali, Tails | Security, privacy |

## File System Hierarchy

```
/
├── bin/          # Essential commands
├── boot/         # Kernel and boot files
├── dev/          # Device files
├── etc/          # Configuration files
├── home/         # User home directories
├── lib/          # Libraries
├── media/        # Removable media
├── mnt/          # Mount points
├── opt/          # Optional software
├── proc/         # Process information
├── root/         # Root user's home
├── sbin/         # System commands
├── tmp/          # Temporary files
├── usr/          # User programs
└── var/          # Variable data (logs)
```

## Navigation Commands

```bash
pwd                 # Print working directory
ls                  # List files
ls -la             # List all with details
cd /path           # Change directory
cd ~              # Go to home
cd ..             # Go up one level
cd -              # Go to previous location
ls -lh            # Human-readable sizes
ls -lt            # Sort by time
```

### File Globbing

```bash
ls *.txt           # All text files
ls file?.txt      # file1.txt, file2.txt
ls [abc]*.txt     # Files starting with a, b, or c
ls **/*.txt       # Recursive (with shopt)
```

## File Operations

```bash
# Create files
touch filename.txt        # Empty file
cat > file.txt           # Create with content
echo "text" > file.txt   # Write content
cp source dest           # Copy
mv source dest          # Move/rename

# Remove files
rm file.txt             # Delete file
rm -r folder/           # Delete folder
rm -rf folder/          # Force delete folder

# Directories
mkdir folder            # Create directory
mkdir -p a/b/c          # Create nested directories
rmdir folder           # Remove empty directory
```

### Viewing Files

```bash
cat file.txt            # Show entire file
head file.txt          # First 10 lines
head -n 20 file.txt    # First 20 lines
tail file.txt          # Last 10 lines
tail -f file.txt       # Follow file changes
less file.txt          # Page through file
more file.txt          # Older pager
wc file.txt            # Line/word/char count
```

## Text Editing

### Using Nano (Easy)

```bash
nano file.txt
# Ctrl+O to save
# Ctrl+X to exit
# Ctrl+W to search
```

### Using Vim (Powerful)

```bash
vim file.txt
# i = insert mode
# Esc = command mode
# :w = save
# :q = quit
# :wq = save and quit
# :q! = quit without saving
```

### Using Sed (Stream Editor)

```bash
sed 's/old/new/g' file.txt          # Replace text
sed -i 's/old/new/g' file.txt       # In-place replace
sed -n '5,10p' file.txt            # Lines 5-10
```

## Permissions

### Understanding Permissions

```
-rwxr-xr--
││││ │││
││││ ││└─ Other (others can read & execute)
││││ └── Group (group can read & execute)
││└──── Owner (owner can read, write, execute)
│└───── Group
└─────── Owner (user:irfan)
```

### Permission Types

| Symbol | Meaning | Numeric |
|--------|---------|---------|
| r | Read | 4 |
| w | Write | 2 |
| x | Execute | 1 |
| - | No permission | 0 |

### Managing Permissions

```bash
# Using letters
chmod u+rwx file.txt          # Owner: rwx
chmod g+rx file.txt           # Group: rx
chmod o+r file.txt            # Others: r
chmod a-x file.txt            # Remove execute from all

# Using numbers
chmod 755 file.txt            # rwxr-xr-x
chmod 644 file.txt            # rw-r--r--
chmod 700 file.txt            # rwx------
chmod 777 file.txt            # rwxrwxrwx ⚠️ Avoid!

# Recursive
chmod -R 755 folder/
```

### Ownership

```bash
chown user file.txt           # Change owner
chown user:group file.txt    # Change owner:group
chgrp group file.txt         # Change group
chown -R user:group folder/  # Recursive
```

## Process Management

```bash
ps                 # Running processes
ps aux            # All processes with details
top               # Interactive process viewer
htop              # Enhanced top

# Process control
kill PID          # Graceful terminate
kill -9 PID      # Force kill
killall name     # Kill by name

# Background
Ctrl+Z           # Suspend process
bg               # Resume in background
fg               # Bring to foreground
command &        # Run in background
nohup command &  # Run after logout
```

## Environment Variables

```bash
# View variables
echo $PATH
env
printenv

# Common variables
$HOME     # User home directory
$PWD      # Current directory
$USER     # Username
$SHELL    # Current shell
$PATH     # Executable search path

# Set variables
export VAR="value"           # This session only
echo 'export VAR="value"' >> ~/.bashrc   # Permanent
```

### PATH Management

```bash
echo $PATH
export PATH=$PATH:/new/path
export PATH=/new/path:$PATH  # Prepend
```

## Searching

```bash
# Find files
find /path -name "*.txt"
find /path -type f
find /path -mtime -7        # Modified in last 7 days
find /path -size +100M     # Larger than 100MB

# Search in files
grep "pattern" file.txt
grep -r "pattern" folder/
grep -i "pattern" file.txt  # Case insensitive
grep -n "pattern" file.txt  # Show line numbers
grep -v "pattern" file.txt  # Invert match

# Modern alternatives
rg "pattern"               # ripgrep (faster)
ag "pattern"               # The Silver Searcher
```

## Networking Basics

```bash
ping host                   # Test connectivity
ifconfig / ip addr        # Show IP addresses
curl url                   # Fetch URL
wget url                   # Download file
ssh user@host              # Remote login
scp file user@host:/path   # Secure copy

# Ports and connections
netstat -tulpn             # Listening ports
ss -tulpn                  # Modern alternative
```

## Package Management

### Debian/Ubuntu (apt)
```bash
sudo apt update             # Update package list
sudo apt upgrade           # Upgrade packages
sudo apt install package   # Install package
sudo apt remove package    # Remove package
sudo apt search term       # Search packages
```

### RHEL/CentOS (yum/dnf)
```bash
sudo yum update            # Update packages
sudo yum install package   # Install package
sudo yum remove package    # Remove package
```

## User Management

```bash
# Users
sudo useradd username      # Add user
sudo userdel username      # Delete user
sudo passwd username      # Set password
su - username             # Switch user
sudo usermod -aG group user  # Add to group

# Groups
groups                    # Your groups
sudo groupadd groupname   # Create group
sudo groupdel groupname  # Delete group
```

## Systemctl (Services)

```bash
sudo systemctl start service     # Start service
sudo systemctl stop service      # Stop service
sudo systemctl restart service   # Restart service
sudo systemctl status service    # Check status
sudo systemctl enable service    # Enable at boot
sudo systemctl disable service   # Disable at boot
```

## Disk Usage

```bash
df -h              # Disk space (human)
du -sh folder/      # Folder size
du -h --max-depth=1 # Size of subfolders
lsblk              # Block devices
mount /dev/sdb1 /mnt  # Mount device
```

## Logs

```bash
# Common log locations
/var/log/syslog           # System messages
/var/log/auth.log         # Authentication
/var/log/apache2/         # Apache logs
/var/log/nginx/           # Nginx logs

# Viewing logs
tail -f /var/log/syslog   # Follow live
journalctl                # Systemd journal
journalctl -u service     # Specific service
```

## Piping and Redirection

```bash
# Pipes
cat file | grep pattern
ls -la | grep txt
command1 | command2

# Redirection
command > file           # Overwrite
command >> file          # Append
command 2> errors.txt    # Stderr
command &> all.txt       # Both stdout and stderr
command < file          # Input from file
```

## Cron Jobs (Scheduling)

```bash
crontab -e              # Edit crontab
crontab -l              # List crontab

# Format: minute hour day month weekday command
* * * * * /script.sh           # Every minute
0 * * * * /script.sh           # Every hour
0 0 * * * /script.sh           # Daily at midnight
0 0 * * 0 /script.sh           # Weekly (Sunday)
```

## Next Steps

➡️ **[Lab: Linux Scavenger Hunt](./labs/lab-02-linux-scavenger.md)** - Practice with exercises

---

**Next: [Module 3: Docker & Containers](../03-docker-containers/README.md)**