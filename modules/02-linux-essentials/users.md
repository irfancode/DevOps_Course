# User Management

## User Commands

```bash
whoami              # Current user
users               # Logged in users
id                  # User ID and groups
```

## Creating Users

```bash
sudo useradd -m username        # Create user with home directory
sudo userdel username        # Delete user
sudo passwd username         # Set password
```

## Modifying Users

```bash
sudo usermod -aG group user   # Add user to group
sudo usermod -L username    # Lock account
sudo usermod -U username   # Unlock account
```

## Groups

```bash
groups                    # List user's groups
getent group             # List all groups
sudo groupadd groupname   # Create group
sudo groupdel groupname  # Delete group
```

##sudo Access

```bash
sudo command              # Run as superuser
su - username           # Switch user
whoami                 # Check current user
```

## Permission Commands

```bash
chown user:group file       # Change owner
chmod 755 file           # Change permissions
chgrp group file         # Change group
```

---

**Next: [Networking Basics](./networking.md)**