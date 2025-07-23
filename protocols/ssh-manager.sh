#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════════
# HR STORE SSH Management Module
# Version: 6.0 Enhanced
# Author: HR STORE Team
# Description: Advanced SSH user management with modern interface
# ═══════════════════════════════════════════════════════════════════════════════

# Color Palette
declare -A COLORS=(
    [RESET]='\033[0m'
    [BOLD]='\033[1m'
    [RED]='\033[0;31m'
    [GREEN]='\033[0;32m'
    [YELLOW]='\033[1;33m'
    [BLUE]='\033[0;34m'
    [PURPLE]='\033[0;35m'
    [CYAN]='\033[0;36m'
    [WHITE]='\033[1;37m'
    [BRIGHT_RED]='\033[1;31m'
    [BRIGHT_GREEN]='\033[1;32m'
    [BRIGHT_YELLOW]='\033[1;33m'
    [BRIGHT_BLUE]='\033[1;34m'
    [BRIGHT_PURPLE]='\033[1;35m'
    [BRIGHT_CYAN]='\033[1;36m'
    [BRIGHT_WHITE]='\033[1;37m'
    [BG_GREEN]='\033[42m'
    [BG_BLUE]='\033[44m'
    [BG_PURPLE]='\033[45m'
)

# Icons
declare -A ICONS=(
    [USER]="👤"
    [USERS]="👥"
    [PLUS]="➕"
    [MINUS]="➖"
    [EDIT]="✏️"
    [DELETE]="🗑️"
    [CHECK]="✅"
    [CROSS]="❌"
    [WARNING]="⚠️"
    [INFO]="ℹ️"
    [CLOCK]="🕐"
    [KEY]="🔑"
    [LOCK]="🔒"
    [UNLOCK]="🔓"
    [SHIELD]="🛡️"
    [GEAR]="⚙️"
    [CHART]="📊"
    [BACK]="⬅️"
    [HOME]="🏠"
)

# Configuration
SSH_CONFIG_DIR="/etc/ssh"
USER_DATA_DIR="/usr/local/hrstore/data/ssh"
LOG_FILE="/var/log/hrstore/ssh-manager.log"

# Ensure directories exist
mkdir -p "$USER_DATA_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

# Logging function
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Display functions
print_header() {
    clear
    echo -e "${COLORS[BG_BLUE]}${COLORS[BRIGHT_WHITE]}"
    echo "╔══════════════════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                                      ║"
    echo "║                    ${ICONS[SHIELD]} HR STORE SSH MANAGEMENT PANEL ${ICONS[SHIELD]}                    ║"
    echo "║                                                                                      ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${COLORS[RESET]}"
    echo
}

print_menu() {
    echo -e "${COLORS[BRIGHT_CYAN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[GEAR]} SSH MANAGEMENT MENU${COLORS[RESET]}                                                      ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}                                                                                      ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}   ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}01${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[PLUS]} Create SSH Account${COLORS[RESET]}           ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}06${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[CHART]} User Statistics${COLORS[RESET]}              ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}   ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}02${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[USERS]} List All Users${COLORS[RESET]}              ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}07${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[LOCK]} Lock User Account${COLORS[RESET]}            ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}   ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}03${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[EDIT]} Extend User Expiry${COLORS[RESET]}          ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}08${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[UNLOCK]} Unlock User Account${COLORS[RESET]}          ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}   ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}04${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[KEY]} Change Password${COLORS[RESET]}             ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}09${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[CHART]} Connection Monitor${COLORS[RESET]}           ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}   ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}05${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[DELETE]} Delete User${COLORS[RESET]}                 ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}10${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[GEAR]} SSH Configuration${COLORS[RESET]}            ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}                                                                                      ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}   ${COLORS[BRIGHT_RED]}[${COLORS[BRIGHT_WHITE]}00${COLORS[BRIGHT_RED]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[BACK]} Back to Main Menu${COLORS[RESET]}           ${COLORS[BRIGHT_RED]}[${COLORS[BRIGHT_WHITE]}99${COLORS[BRIGHT_RED]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[HOME]} Exit${COLORS[RESET]}                         ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}                                                                                      ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
}

# User management functions
create_ssh_user() {
    clear
    print_header
    
    echo -e "${COLORS[BRIGHT_GREEN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[PLUS]} CREATE NEW SSH ACCOUNT${COLORS[RESET]}                                                  ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
    
    # Get username
    echo -ne "${COLORS[BRIGHT_CYAN]}${ICONS[USER]} Enter username: ${COLORS[RESET]}"
    read -r username
    
    # Validate username
    if [[ -z "$username" ]]; then
        echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} Username cannot be empty!${COLORS[RESET]}"
        sleep 2
        return
    fi
    
    if id "$username" &>/dev/null; then
        echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} User '$username' already exists!${COLORS[RESET]}"
        sleep 2
        return
    fi
    
    # Get password
    echo -ne "${COLORS[BRIGHT_CYAN]}${ICONS[KEY]} Enter password: ${COLORS[RESET]}"
    read -r password
    
    if [[ -z "$password" ]]; then
        echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} Password cannot be empty!${COLORS[RESET]}"
        sleep 2
        return
    fi
    
    # Get expiry days
    echo -ne "${COLORS[BRIGHT_CYAN]}${ICONS[CLOCK]} Enter expiry days (default: 30): ${COLORS[RESET]}"
    read -r expiry_days
    expiry_days=${expiry_days:-30}
    
    # Calculate expiry date
    expiry_date=$(date -d "+$expiry_days days" '+%Y-%m-%d')
    
    echo
    echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Creating SSH account with the following details:${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}Username: ${COLORS[BRIGHT_WHITE]}$username${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}Password: ${COLORS[BRIGHT_WHITE]}$password${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}Expiry Date: ${COLORS[BRIGHT_WHITE]}$expiry_date${COLORS[RESET]}"
    echo
    
    echo -ne "${COLORS[BRIGHT_CYAN]}${ICONS[WARNING]} Proceed with creation? [y/N]: ${COLORS[RESET]}"
    read -r confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        # Create user
        if useradd -m -s /bin/bash -e "$expiry_date" "$username" 2>/dev/null; then
            # Set password
            echo "$username:$password" | chpasswd
            
            # Save user data
            echo "$username:$password:$expiry_date:$(date '+%Y-%m-%d %H:%M:%S')" >> "$USER_DATA_DIR/users.txt"
            
            # Log action
            log_action "SSH user created: $username (expires: $expiry_date)"
            
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[CHECK]} SSH account created successfully!${COLORS[RESET]}"
            
            # Display connection info
            echo
            echo -e "${COLORS[BRIGHT_CYAN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
            echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[INFO]} CONNECTION INFORMATION${COLORS[RESET]}                                                ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
            echo -e "${COLORS[BRIGHT_CYAN]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
            echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}Host/IP${COLORS[RESET]}     : ${COLORS[BRIGHT_WHITE]}$(curl -s ipv4.icanhazip.com 2>/dev/null || echo "Your-Server-IP")${COLORS[RESET]}"
            echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}Username${COLORS[RESET]}   : ${COLORS[BRIGHT_WHITE]}$username${COLORS[RESET]}"
            echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}Password${COLORS[RESET]}   : ${COLORS[BRIGHT_WHITE]}$password${COLORS[RESET]}"
            echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}Port${COLORS[RESET]}       : ${COLORS[BRIGHT_WHITE]}22${COLORS[RESET]}"
            echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}Expires${COLORS[RESET]}    : ${COLORS[BRIGHT_WHITE]}$expiry_date${COLORS[RESET]}"
            echo -e "${COLORS[BRIGHT_CYAN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
        else
            echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} Failed to create SSH account!${COLORS[RESET]}"
            log_action "Failed to create SSH user: $username"
        fi
    else
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Account creation cancelled.${COLORS[RESET]}"
    fi
    
    echo
    echo -ne "${COLORS[BRIGHT_CYAN]}Press Enter to continue...${COLORS[RESET]}"
    read
}

list_ssh_users() {
    clear
    print_header
    
    echo -e "${COLORS[BRIGHT_GREEN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[USERS]} SSH USERS LIST${COLORS[RESET]}                                                          ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
    
    # Get current SSH users
    local ssh_users=()
    while IFS=: read -r username _ uid _ _ home shell; do
        if [[ $uid -ge 1000 && $uid -le 60000 && "$shell" != "/usr/sbin/nologin" && "$shell" != "/bin/false" ]]; then
            ssh_users+=("$username")
        fi
    done < /etc/passwd
    
    if [[ ${#ssh_users[@]} -eq 0 ]]; then
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} No SSH users found.${COLORS[RESET]}"
    else
        echo -e "${COLORS[BRIGHT_CYAN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BOLD]}Username${COLORS[RESET]}     ${COLORS[BOLD]}Status${COLORS[RESET]}    ${COLORS[BOLD]}Expiry Date${COLORS[RESET]}    ${COLORS[BOLD]}Last Login${COLORS[RESET]}           ${COLORS[BOLD]}Home Directory${COLORS[RESET]}      ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
        
        for user in "${ssh_users[@]}"; do
            # Get user status
            local status="${COLORS[BRIGHT_GREEN]}Active${COLORS[RESET]}"
            if passwd -S "$user" 2>/dev/null | grep -q "L"; then
                status="${COLORS[BRIGHT_RED]}Locked${COLORS[RESET]}"
            fi
            
            # Get expiry date
            local expiry=$(chage -l "$user" 2>/dev/null | grep "Account expires" | cut -d: -f2 | xargs)
            [[ "$expiry" == "never" ]] && expiry="${COLORS[BRIGHT_GREEN]}Never${COLORS[RESET]}"
            
            # Get last login
            local last_login=$(lastlog -u "$user" 2>/dev/null | tail -1 | awk '{print $4, $5, $6, $7}')
            [[ "$last_login" == "** **" ]] && last_login="${COLORS[BRIGHT_YELLOW]}Never${COLORS[RESET]}"
            
            # Get home directory
            local home_dir=$(getent passwd "$user" | cut -d: -f6)
            
            printf "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} %-12s %-12s %-15s %-20s %-20s ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}\n" \
                "$user" "$status" "$expiry" "$last_login" "$home_dir"
        done
        
        echo -e "${COLORS[BRIGHT_CYAN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
        echo
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Total SSH users: ${COLORS[BRIGHT_WHITE]}${#ssh_users[@]}${COLORS[RESET]}"
    fi
    
    echo
    echo -ne "${COLORS[BRIGHT_CYAN]}Press Enter to continue...${COLORS[RESET]}"
    read
}

delete_ssh_user() {
    clear
    print_header
    
    echo -e "${COLORS[BRIGHT_RED]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_RED]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[DELETE]} DELETE SSH USER${COLORS[RESET]}                                                         ${COLORS[BRIGHT_RED]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_RED]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
    
    # List current users first
    echo -e "${COLORS[BRIGHT_CYAN]}${ICONS[USERS]} Current SSH users:${COLORS[RESET]}"
    local users=()
    while IFS=: read -r username _ uid _ _ home shell; do
        if [[ $uid -ge 1000 && $uid -le 60000 && "$shell" != "/usr/sbin/nologin" && "$shell" != "/bin/false" ]]; then
            users+=("$username")
            echo -e "  ${COLORS[BRIGHT_WHITE]}• $username${COLORS[RESET]}"
        fi
    done < /etc/passwd
    
    if [[ ${#users[@]} -eq 0 ]]; then
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} No SSH users found to delete.${COLORS[RESET]}"
        echo -ne "${COLORS[BRIGHT_CYAN]}Press Enter to continue...${COLORS[RESET]}"
        read
        return
    fi
    
    echo
    echo -ne "${COLORS[BRIGHT_CYAN]}${ICONS[USER]} Enter username to delete: ${COLORS[RESET]}"
    read -r username
    
    if [[ -z "$username" ]]; then
        echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} Username cannot be empty!${COLORS[RESET]}"
        sleep 2
        return
    fi
    
    if ! id "$username" &>/dev/null; then
        echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} User '$username' does not exist!${COLORS[RESET]}"
        sleep 2
        return
    fi
    
    echo
    echo -e "${COLORS[BRIGHT_RED]}${ICONS[WARNING]} WARNING: This will permanently delete the user '$username' and all their data!${COLORS[RESET]}"
    echo -ne "${COLORS[BRIGHT_CYAN]}${ICONS[WARNING]} Are you sure? Type 'DELETE' to confirm: ${COLORS[RESET]}"
    read -r confirm
    
    if [[ "$confirm" == "DELETE" ]]; then
        # Kill user processes
        pkill -u "$username" 2>/dev/null
        
        # Delete user and home directory
        if userdel -r "$username" 2>/dev/null; then
            # Remove from user data file
            sed -i "/^$username:/d" "$USER_DATA_DIR/users.txt" 2>/dev/null
            
            log_action "SSH user deleted: $username"
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[CHECK]} User '$username' deleted successfully!${COLORS[RESET]}"
        else
            echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} Failed to delete user '$username'!${COLORS[RESET]}"
            log_action "Failed to delete SSH user: $username"
        fi
    else
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} User deletion cancelled.${COLORS[RESET]}"
    fi
    
    echo
    echo -ne "${COLORS[BRIGHT_CYAN]}Press Enter to continue...${COLORS[RESET]}"
    read
}

# Connection monitor
connection_monitor() {
    clear
    print_header
    
    echo -e "${COLORS[BRIGHT_GREEN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[CHART]} SSH CONNECTION MONITOR${COLORS[RESET]}                                                ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
    
    # Active SSH connections
    echo -e "${COLORS[BRIGHT_CYAN]}${ICONS[USERS]} Active SSH Connections:${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BOLD]}User${COLORS[RESET]}         ${COLORS[BOLD]}TTY${COLORS[RESET]}      ${COLORS[BOLD]}From${COLORS[RESET]}              ${COLORS[BOLD]}Login Time${COLORS[RESET]}        ${COLORS[BOLD]}Idle${COLORS[RESET]}     ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    
    local connection_count=0
    while read -r line; do
        if [[ -n "$line" ]]; then
            ((connection_count++))
            echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} $line"
        fi
    done < <(who | awk '{printf "%-12s %-8s %-16s %-16s %-8s\n", $1, $2, $5, $3" "$4, $6}')
    
    if [[ $connection_count -eq 0 ]]; then
        echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BRIGHT_YELLOW]}No active SSH connections${COLORS[RESET]}"
    fi
    
    echo -e "${COLORS[BRIGHT_CYAN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
    
    # SSH service status
    echo -e "${COLORS[BRIGHT_CYAN]}${ICONS[GEAR]} SSH Service Status:${COLORS[RESET]}"
    if systemctl is-active --quiet ssh; then
        echo -e "  ${COLORS[BRIGHT_GREEN]}${ICONS[CHECK]} SSH service is running${COLORS[RESET]}"
    else
        echo -e "  ${COLORS[BRIGHT_RED]}${ICONS[CROSS]} SSH service is not running${COLORS[RESET]}"
    fi
    
    # SSH port
    local ssh_port=$(grep -E "^Port" /etc/ssh/sshd_config 2>/dev/null | awk '{print $2}' || echo "22")
    echo -e "  ${COLORS[BRIGHT_CYAN]}${ICONS[GEAR]} SSH Port: ${COLORS[BRIGHT_WHITE]}$ssh_port${COLORS[RESET]}"
    
    # Failed login attempts
    local failed_attempts=$(grep "Failed password" /var/log/auth.log 2>/dev/null | tail -10 | wc -l)
    echo -e "  ${COLORS[BRIGHT_YELLOW]}${ICONS[WARNING]} Recent failed attempts: ${COLORS[BRIGHT_WHITE]}$failed_attempts${COLORS[RESET]}"
    
    echo
    echo -ne "${COLORS[BRIGHT_CYAN]}Press Enter to continue...${COLORS[RESET]}"
    read
}

# Main menu handler
handle_ssh_menu() {
    while true; do
        clear
        print_header
        print_menu
        
        echo -ne "${COLORS[BRIGHT_CYAN]}┌─[${COLORS[BRIGHT_WHITE]}HR-STORE-SSH${COLORS[BRIGHT_CYAN]}]─[${COLORS[BRIGHT_YELLOW]}$(whoami)${COLORS[BRIGHT_CYAN]}]─[${COLORS[BRIGHT_WHITE]}$(date +%H:%M:%S)${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]}\n"
        echo -ne "${COLORS[BRIGHT_CYAN]}└─${COLORS[BRIGHT_WHITE]}Select Option${COLORS[BRIGHT_CYAN]}: ${COLORS[RESET]}"
        read -r choice
        
        case $choice in
            1|01) create_ssh_user ;;
            2|02) list_ssh_users ;;
            3|03) echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Feature coming soon!${COLORS[RESET]}"; sleep 2 ;;
            4|04) echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Feature coming soon!${COLORS[RESET]}"; sleep 2 ;;
            5|05) delete_ssh_user ;;
            6|06) echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Feature coming soon!${COLORS[RESET]}"; sleep 2 ;;
            7|07) echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Feature coming soon!${COLORS[RESET]}"; sleep 2 ;;
            8|08) echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Feature coming soon!${COLORS[RESET]}"; sleep 2 ;;
            9|09) connection_monitor ;;
            10) echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Feature coming soon!${COLORS[RESET]}"; sleep 2 ;;
            0|00) return 0 ;;
            99|x|X) exit 0 ;;
            *) 
                echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} Invalid option: $choice${COLORS[RESET]}"
                sleep 2
                ;;
        esac
    done
}

# Script entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    handle_ssh_menu
fi

