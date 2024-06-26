#!/bin/bash

# Function to log messages
log() {
    local message="$1"
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $message"
}

# Function to compress a directory
compress_directory() {
    local dir_path="$1"
    local archive_name="$2"
    local output_dir="$3"

    # Log message indicating the compression process is starting
    log "Compressing directory $dir_path into $output_dir/$archive_name..."
    # Compress the directory into a tar.gz archive
    if tar -czf "$output_dir/$archive_name" -C "$dir_path" .; then
        # Log message indicating successful compression
        log "Directory $dir_path compressed into $output_dir/$archive_name."
    else
        # Log message indicating compression error and exit script with error code 1
        log "Error compressing directory $dir_path."
        exit 1
    fi
}

# Function to upload the compressed file to a remote server
upload_to_remote() {
    local archive_name="$1"
    local remote_user="$2"
    local remote_host="$3"
    local remote_port="$4"
    local remote_path="$5"
    local output_dir="$6"

    # Log message indicating the upload process is starting
    log "Uploading $output_dir/$archive_name to $remote_user@$remote_host:$remote_path..."
    # Upload the file using scp with specified parameters
    if scp -P "$remote_port" "$output_dir/$archive_name" "$remote_user@$remote_host:$remote_path"; then
        # Log message indicating successful upload
        log "File $archive_name uploaded to $remote_user@$remote_host:$remote_path."
    else
        # Log message indicating upload error and exit script with error code 1
        log "Error uploading file $archive_name to remote server."
        exit 1
    fi
}

# Check for required arguments
if [[ $# -ne 6 ]]; then
    echo "Usage: $0 <directory_to_backup> <remote_user> <remote_host> <remote_port> <remote_path> <output_directory>"
    exit 1
fi

# Assign arguments to variables
dir_to_backup="$1"
remote_user="$2"
remote_host="$3"
remote_port="$4"
remote_path="$5"
output_dir="$6"

# Log message indicating the start of the backup process and print provided parameters
log "Starting backup process..."
log "Directory to backup: $dir_to_backup"
log "Remote user: $remote_user"
log "Remote host: $remote_host"
log "Remote port: $remote_port"
log "Remote path: $remote_path"
log "Output directory: $output_dir"

# Ensure the directory to backup exists
if [[ ! -d "$dir_to_backup" ]]; then
    # Log message indicating directory doesn't exist and exit script with error code 1
    log "Directory to backup $dir_to_backup does not exist!"
    exit 1
fi

# Ensure the output directory exists
if [[ ! -d "$output_dir" ]]; then
    # Log message indicating output directory doesn't exist and exit script with error code 1
    log "Output directory $output_dir does not exist!"
    exit 1
fi

# Generate archive name based on directory name and current timestamp
archive_name="$(basename "$dir_to_backup")_$(date +"%Y%m%d%H%M%S").tar.gz"
log "Archive name: $archive_name"

# Compress the directory
compress_directory "$dir_to_backup" "$archive_name" "$output_dir"

# Upload the compressed file to the remote server
upload_to_remote "$archive_name" "$remote_user" "$remote_host" "$remote_port" "$remote_path" "$output_dir"

# Clean up local archive file
log "Removing local archive file $output_dir/$archive_name..."
if rm "$output_dir/$archive_name"; then
    # Log message indicating successful removal of local archive
    log "Local archive file $output_dir/$archive_name removed."
else
    # Log message indicating error in removing local archive
    log "Error removing local archive file $output_dir/$archive_name."
fi

# Log message indicating completion of backup process
log "Backup process completed."

