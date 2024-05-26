#!/bin/bash

# Function to delete user
delete_user() {
    local email="$1"

    # Extract username from email
    local username=$(echo "$email" | awk -F '@' '{print $1}' | awk -F '.' '{print substr($1, 1, 1) $2}')

    # Get the current user's username
    local current_user=$(whoami)

    # Check if the username matches the current user
    if [[ "$username" == "$current_user" ]]; then
        echo "Skipping deletion of current user: $username"
        return
    fi

    echo "Deleting user: $username"
    echo "Email: $email"

    # Delete user and their home directory
    sudo userdel -r "$username"

    # Remove any shared folders and symbolic links
    local shared_folder="$4"
    if [[ -n "$shared_folder" ]]; then
        shared_folder=$(echo "$shared_folder" | xargs)  # Trim whitespace
        sudo rm -rf "$shared_folder"
        sudo rm -f "/home/$username/shared"
    fi
}

# Read the CSV file
file_path="users.csv"

if [[ ! -f "$file_path" ]]; then
    echo "File not found!"
    exit 1
fi

while IFS=';' read -r email birth_date groups shared_folder; do
    # Skip the header
    if [[ "$email" == "e-mail" ]]; then
        continue
    fi

    delete_user "$email" "$birth_date" "$groups" "$shared_folder"
done < "$file_path"
