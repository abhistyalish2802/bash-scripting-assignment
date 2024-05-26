# Bash Scripting Assignment (30% OF FINAL MARKS)
IA616001 OPERATING SYSTEM
SUBMITTED TO: WILl
SUBMITTED ON:- 26/05/2024

##  Details
- **Full Name**: Abhishek Choudhary
- **Student Code (Login Name)**: 1000118874
- **DUE DATE**:26/05/2024

## Project Overview
This repository hosts two primary Bash scripts designed for the IN616001 Operating Systems Concepts course at Otago Polytechnic. These scripts are aimed at automating administrative tasks on an Ubuntu Linux server.

### Task 1: Creating a User Environment
The first script automates the creation of user accounts and configures their environments based on data provided in a CSV file.

#### INSTRUCTIONS :
    Open your terminal.
    Create a file where you want to write the script.
    Ensure you have the CSV file generated from the office. If you don't have one, go to "Save As" and change the format to CSV. (Note: The script has the file path hardcoded. If you want to run your own script, you'll need to modify the path.)
    After following all the commands like chmod +x and ./directory, you will be prompted with a question asking if you want to create the user. If you type "yes", it will be executed.
    You can view all the information inside the user_creation.log, which will be created where the script is located.

### Task 2: Backup Script
The second script compresses a designated directory and uploads the backup to a remote server. Additionally, it creates a backup in the same remote location on this machine.

#### INSTRUCTIONS :
    Open your terminal.
    Create a file where you want to write the script. (Use the nano command. After writing the script, press CTRL+X, then Enter).
    The path is not hardcoded; you can use your own location, but there is a structure you need to follow: <directory_to_backup> <remote_user> <remote_host> <remote_port> <remote_path> <output_directory>. 
    In my case, it was:
        Remote user: abhishek
        Remote host: backupserver.com
        Remote port: 22
        Remote path: /home/abhishek/backups
        Output directory: /tmp

## Prerequisites
- Ubuntu Linux system
- Bash shell
- `scp` command for remote file transfer
- Git (for version control)
- CSV file containing user data for Task 1

## Project Structure

├── README.md
├── BSA_Self_Assessment.txt
├── task1
│ ├── abhishek_user.sh
│ ├── users.csv
│ └── logs
└── task2
├── backup.sh
└── testdir
