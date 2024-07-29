#!/data/data/com.termux/files/usr/bin/dash
# Stop script on any error
set -e

# Function for displaying welcome message
display_welcome_message() {
    clear
    echo "|-------------------------------------------|"
    echo "|   Welcome to the Technical Utility Zone   |"
    echo "|-------------------------------------------|"
    echo "User: $(whoami)"
    echo "Current date: $(date '+%Y-%m-%d')"
    echo "Current time: $(date '+%H:%M:%S')"
    sleep 2
}

# Function for displaying exit message
display_exit_message() {
    sleep 1
    clear
    echo "|-------------------------------------------|"
    echo "|  Exiting Technical Utility Zone...        |"
    echo "|-------------------------------------------|"
    echo "Thank you for using the Technical Utility Zone."
    echo "Have a great day!"
    sleep 1
}

# Function to set password for an existing user
configure_user_password() {
    sleep 1
    existing_username=$(whoami)
    password_folder="/data/data/com.termux/files/passwords"
    password_file="$password_folder/password.txt"

    if [ ! -d "$password_folder" ]; then
        mkdir -p "$password_folder"
        chmod 700 "$password_folder"
    fi

    if [ -f "$password_file" ]; then
        previous_password=$(cat "$password_file")
    else
        previous_password=""
    fi

    while true; do
        echo -n "Enter new password: "
        stty -echo
        read password
        stty echo
        echo

        echo -n "Retype new password: "
        stty -echo
        read password_confirm
        stty echo
        echo

        if [ "$password" = "$password_confirm" ]; then
            if [ "$password" = "$previous_password" ]; then
                echo "You entered the same password as before. Please provide a different one."
            else
                if [ -z "$password" ]; then
                    echo "Password cannot be empty. Please provide a valid password."
                elif [ ${#password} -lt 8 ]; then
                    echo "Password must be at least 8 characters long. Please try again."
                else
                    echo "$password" > "$password_file"
                    chmod 400 "$password_file"
                    echo "Password for user $existing_username set successfully."
                    sleep 1
                    break
                fi
            fi
        else
            echo "Sorry, passwords do not match."
        fi
    done
}

# Function to update and upgrade system packages
update_system_packages() {
    sleep 1
    clear
    echo "|-------------------------------------------|"
    echo "|      Updating system packages...          |"
    echo "|-------------------------------------------|"
    echo "Updating system packages..."
    pkg update -y && pkg upgrade -y
    pkg install -y root-repo x11-repo
    sleep 1
    echo "System packages updated successfully."
}

# Function to install system dependencies
install_required_dependencies() {
    sleep 1
    clear
    echo "|-------------------------------------------|"
    echo "|  Installing system dependencies...        |"
    echo "|-------------------------------------------|"
    echo "Installing system dependencies..."
    apt install -y nmap wireshark-cli tmux nano vim neofetch tcpdump traceroute dnsutils build-essential python git curl wget nodejs openssh docker php xfce4 glmark2 mpv firefox
    echo "System dependencies installed successfully."
}

# Function to install Python packages
install_python_packages() {
    sleep 1
    clear
    echo "|-------------------------------------------|"
    echo "|  Installing Python packages...            |"
    echo "|-------------------------------------------|"
    echo "Installing Python packages..."
    pip install requests flask
    echo "Python packages installed successfully."
}

# Function to install Composer
install_composer() {
    sleep 1
    clear
    echo "|-------------------------------------------|"
    echo "|      Installing Composer...               |"
    echo "|-------------------------------------------|"
    echo "Installing Composer..."
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/data/data/com.termux/files/usr/bin --filename=composer
    echo "Composer installed successfully."
}

# Function to make the password directory read-only
secure_password_directory() {
    password_folder="/data/data/com.termux/files/passwords"
    chmod -R 555 "$password_folder"
    echo "The directory $password_folder is now read-only."
}

# Function to clone repositories and execute their setup scripts
setup_repositories() {
    sleep 1
    clear
    echo "|-------------------------------------------|"
    echo "|  Cloning and setting up repositories...   |"
    echo "|-------------------------------------------|"

    # Clone termux-desktop
    echo "Cloning termux-desktop..."
    git clone --depth=1 https://github.com/adi1090x/termux-desktop.git || { echo "Failed to clone termux-desktop"; exit 1; }

    # Clone Termux-All-Packages-Install
    echo "Cloning Termux-All-Packages-Install..."
    git clone https://github.com/Bluehathacker/Termux-All-Packages-Install || { echo "Failed to clone Termux-All-Packages-Install"; exit 1; }

    sleep 1
    echo "Repositories cloned and setup completed."
}

# Main function
main() {
    display_welcome_message
    configure_user_password
    secure_password_directory
    update_system_packages
    install_required_dependencies
    install_python_packages
    install_composer
    setup_repositories
    display_exit_message
}

main