#!/bin/bash

# Function to create user
create_user() {
    local email="$1"
    local birth_date="$2"
    local groups="$3"
    local shared_folder="$4"

    # Extract username from email
    local username=$(echo "$email" | awk -F '@' '{print $1}' | awk -F '.' '{print substr($1, 1, 1) $2}')

    # Extract password from birth date
    local password=$(echo "$birth_date" | awk -F '/' '{print $2 $1}')

    echo "Creating user: $username"
    echo "Email: $email"
    echo "Birth Date: $birth_date"
    echo "Groups: $groups"
    echo "Shared Folder: $shared_folder"
    echo "Password: $password"

    # Add user creation logic here
    sudo useradd -m -s /bin/bash -p $(openssl passwd -1 "$password") "$username"
    
    # Assign user to groups
    if [[ -n "$groups" ]]; then
        IFS=' ' read -r -a group_array <<< "$groups"
        for group in "${group_array[@]}"; do
            group=$(echo "$group" | xargs)  # Trim whitespace
            sudo groupadd -f "$group"
            sudo usermod -aG "$group" "$username"
        done
    fi

    # Setup shared folder if provided
    if [[ -n "${shared_folder// }" ]]; then
        shared_folder=$(echo "$shared_folder" | xargs)  # Trim whitespace
        sudo mkdir -p "$shared_folder"
        sudo chown "$username":"$username" "$shared_folder"
        sudo chmod 770 "$shared_folder"
        sudo ln -s "$shared_folder" "/home/$username/shared"
    fi
    
    # Enforce password change at first login
    sudo chage -d 0 "$username"
    
    # Create alias if user is in sudo group
    if [[ "$groups" == *"sudo"* ]]; then
        echo "alias myls='ls -la'" | sudo tee -a "/home/$username/.bash_aliases" >/dev/null
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

    create_user "$email" "$birth_date" "$groups" "$shared_folder"
done < "$file_path"

