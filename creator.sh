#!/bin/bash

# Function to create a new Linux command
create_command() {
    clear
    echo "Enter the name for your new command:"
    read -p "> " command_name
    
    # Validate command name
    if [[ ! "$command_name" =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Error: Command name must be alphanumeric (letters, numbers, underscores) only."
        return 1
    fi
    
    echo "Enter the directory path where your script file is located:"
    read -p "> " directory_path
    
    # Validate directory path
    if [[ ! -d "$directory_path" ]]; then
        echo "Error: Directory not found."
        return 1
    fi
    
    # List .sh files in the directory
    echo "Select the script file (.sh) to make it a command:"
    select file in "$directory_path"/*.sh; do
        if [ -n "$file" ]; then
            chmod +x "$file"
            sudo ln -s "$file" "/usr/local/bin/$command_name"
            echo "Command '$command_name' created successfully!"
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done
    
    # Pause and wait for any key press to continue
    read -rsp $'Press any key to continue...\n' -n1 key
}

# Function to delete a created Linux command
delete_command() {
    clear
    echo "Enter the name of the command to delete:"
    read -p "> " command_name
    
    # Check if command exists
    if ! command -v "$command_name" &> /dev/null; then
        echo "Error: Command '$command_name' not found."
        return 1
    fi
    
    # Remove symbolic link from /usr/local/bin
    sudo rm "/usr/local/bin/$command_name"
    
    echo "Command '$command_name' deleted successfully!"
    
    # Pause and wait for any key press to continue
    read -rsp $'Press any key to continue...\n' -n1 key
}

# Function to list created commands
list_commands() {
    clear
    echo "===== List of My Commands ====="
    for command_path in /usr/local/bin/*; do
        if [ -L "$command_path" ]; then
            command_name=$(basename "$command_path")
            echo "$command_name"
        fi
    done
    echo "================================"
    
    # Pause and wait for any key press to continue
    read -rsp $'Press any key to continue...\n' -n1 key
}

# Display menu using whiptail
while true; do
    option=$(whiptail --clear --title "Custom Command Manager Menu" --menu "Choose an option:" 15 60 4 \
        "Create Linux Command" "Create a new Linux command" \
        "Delete My Commands" "Delete a previously created command" \
        "List My Commands" "List all created commands" \
        "Exit" "Exit the script" \
        3>&1 1>&2 2>&3)
    
    exit_status=$?
    if [ $exit_status -eq 0 ]; then
        case "$option" in
            "Create Linux Command") create_command ;;
            "Delete My Commands") delete_command ;;
            "List My Commands") list_commands ;;
            "Exit") echo "Exiting."; break ;;
            *) echo "Invalid option. Please choose again." ;;
        esac
    else
        echo "No option chosen. Exiting."
        break
    fi
done
