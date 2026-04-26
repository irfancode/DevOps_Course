# File System Navigation

## Directories

```bash
cd /path/to/directory    # Change directory
ls                   # List files
ls -l               # Long format
ls -la              # Hidden files
ls -lh              # Human readable sizes
```

## Path Types

| Type | Example | Description |
|------|--------|-------------|
| Absolute | `/home/user/documents` | Full path from root |
| Relative | `../documents` | Relative to current dir |
| Home | `~` or `$HOME` | User's home directory |

## Important Directories

```
/           # Root directory
/home       # User home directories
/tmp        # Temporary files
/var        # Variable data (logs)
/etc        # Configuration
/usr       # User programs
```

## File Commands

```bash
touch file.txt          # Create empty file
cp source dest        # Copy
mv source dest       # Move/rename
rm file.txt         # Delete
mkdir newdir        # Create directory
rmdir newdir       # Delete empty directory
```

## Searching

```bash
find /path -name "*.txt"
find /path -type f
find /path -mtime -7
```

## Symbolic Links

```bash
ln -s target link_name    # Create symbolic link
ls -l                    # View links
```

---

**Next: [User Management](./users.md)**