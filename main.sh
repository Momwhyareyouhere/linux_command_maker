#!/bin/bash


create_command() {
    clear
    echo "Enter the name for your new command:"
    read -p "> " command_name
    

    if [[ ! "$command_name" =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Error: Command name must be alphanumeric (letters, numbers, underscores) only."
        return 1
    fi
    
    echo "Enter the directory path where your script file is located:"
    read -p "> " directory_path
    

    if [[ ! -d "$directory_path" ]]; then
        echo "Error: Directory not found."
        return 1
    fi
    

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
    

    read -rsp $'Press any key to continue...\n' -n1 key
}


delete_command() {
    clear
    echo "Enter the name of the command to delete:"
    read -p "> " command_name
    

    if ! command -v "$command_name" &> /dev/null; then
        echo "Error: Command '$command_name' not found."
        return 1
    fi
    

    sudo rm "/usr/local/bin/$command_name"
    
    echo "Command '$command_name' deleted successfully!"
    

    read -rsp $'Press any key to continue...\n' -n1 key
}

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
    

    read -rsp $'Press any key to continue...\n' -n1 key
}


create_example_command() {
    if command -v greet &> /dev/null; then
        echo "You have already created the 'greet' command."
    else
        echo "#!/bin/bash" > example.sh
        echo 'echo "Hello, world!"' >> example.sh
        chmod +x example.sh
        sudo mv example.sh /usr/local/bin/greet
        echo "Created an example command called 'greet'."
    fi
    

    read -rsp $'Press any key to continue...\n' -n1 key
}


while true; do
    option=$(whiptail --clear --title "Custom Command Manager Menu" --menu "Choose an option:" 15 60 5 \
        "Create Linux Command" "Create a new Linux command" \
        "Delete My Commands" "Delete a previously created command" \
        "List My Commands" "List all created commands" \
        "Example Command" "Create an example command (greet)" \
        "Exit" "Exit the script" \
        3>&1 1>&2 2>&3)
    
    exit_status=$?
    if [ $exit_status -eq 0 ]; then
        case "$option" in
            "Create Linux Command") create_command ;;
            "Delete My Commands") delete_command ;;
            "List My Commands") list_commands ;;
            "Example Command") create_example_command ;;
            "Exit") echo "Exiting."; break ;;
            *) echo "Invalid option. Please choose again." ;;
        esac
    else
        echo "No option chosen. Exiting."
        break
    fi
done
