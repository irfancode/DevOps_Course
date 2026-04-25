# Lab 2: Linux Scavenger Hunt 🔍

Time: 45 minutes | Difficulty: Beginner

## Scenario

You've been hired as a Junior DevOps Engineer at a startup. Your mentor has hidden clues throughout the Linux system. Find all the clues to prove you're ready for the job!

---

## Setup

```bash
# Create the hunt environment
mkdir -p ~/linux-hunt
cd ~/linux-hunt

# Create the clue files
echo "Great start! You found Clue 1." > clue1.txt
echo "Clue 2 is hidden in a directory called 'mission'" > clue2_dummy.txt
mkdir mission
echo "Excellent! Clue 2 found in the mission directory." > mission/clue2.txt
echo "Clue 3 waits in a hidden file." > clue3_dummy.txt
echo "🎯 Clue 3 discovered! You're getting good at this!" > .secret_clue3
chmod 444 .secret_clue3
mkdir archives
echo "Clue 4 is compressed. Unzip to reveal!" > clue4.txt
cd archives
tar -czf clue4.tar.gz ../clue4.txt
cd ..
```

---

## Part 1: File System Navigation (15 min)

### Challenge 1.1: Where Am I?
Run the command to see your current location.

### Challenge 1.2: List Everything
List all files including hidden ones. How many items do you see?

### Challenge 1.3: Find Clue 1
Display the contents of `clue1.txt`.

---

## Part 2: File Operations (15 min)

### Challenge 2.1: Navigate
Go into the `mission` directory and display `clue2.txt`.

### Challenge 2.2: Find Hidden Clue
Search for a file containing "Clue 3" in the current directory.

### Challenge 2.3: Permissions Check
Check if you can modify the `.secret_clue3` file. What happens if you try?

### Challenge 2.4: Fix Permissions
Fix the permissions so you can read the secret clue.

---

## Part 3: Text Processing (10 min)

### Challenge 3.1: Word Count
Count the number of words in all clue files.

### Challenge 3.2: Search the Logs
Create a log file and search for specific patterns:
```bash
echo "INFO: Server started
ERROR: Connection failed
INFO: User logged in
WARN: High memory usage
ERROR: Timeout occurred
INFO: Backup completed" > ~/linux-hunt/log.txt
```
Search for lines containing "ERROR".

### Challenge 3.3: Piping Practice
Use pipes to show only the filenames from `/etc` that contain "pass".

---

## Part 4: Archives (5 min)

### Challenge 4.1: Extract
Go to the `archives` folder, extract the archive, and read `clue4.txt`.

---

## Bonus Challenges

### Bonus 1: Environment Variables
Find and display your `HOME` path and your `USER` name using environment variables.

### Bonus 2: Process Hunt
Start a background process and find its PID.

### Bonus 3: Disk Space
Check available disk space on your system.

---

## Solution Script

When you're done, run this to see how you did:

```bash
#!/bin/bash
echo "===== Linux Scavenger Hunt Results ====="
echo ""
echo "1. Current location: $(pwd)"
echo "2. Files found: $(ls -la | grep -c '^')"
echo "3. Clue 1: $(cat clue1.txt)"
echo "4. Clue 2: $(cat mission/clue2.txt)"
echo "5. Clue 3: $(cat .secret_clue3)"
echo "6. Clue 4: $(cat archives/clue4.txt)"
echo ""
echo "🎉 Congratulations! You found all the clues!"
```

---

## Cleanup

```bash
cd ~
rm -rf ~/linux-hunt
```

---

**Lab Complete! 🎉**

Next: [Module 3: Docker & Containers](../03-docker-containers/README.md)