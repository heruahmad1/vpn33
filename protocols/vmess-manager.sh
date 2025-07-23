#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════════
# HR STORE VMESS Management Module
# Version: 6.0 Enhanced
# Author: HR STORE Team
# Description: Advanced VMESS user management with modern interface
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
    [SHIELD]="🛡️"
    [ROCKET]="🚀"
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
    [GEAR]="⚙️"
    [CHART]="📊"
    [BACK]="⬅️"
    [HOME]="🏠"
    [GLOBE]="🌐"
    [LINK]="🔗"
    [QR]="📱"
)

# Configuration
XRAY_CONFIG="/etc/xray/config.json"
VMESS_DATA_DIR="/usr/local/hrstore/data/vmess"
LOG_FILE="/var/log/hrstore/vmess-manager.log"
DOMAIN=$(curl -s ipv4.icanhazip.com 2>/dev/null || echo "your-domain.com")

# Ensure directories exist
mkdir -p "$VMESS_DATA_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

# Logging function
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# UUID generator
generate_uuid() {
    cat /proc/sys/kernel/random/uuid
}

# Display functions
print_header() {
    clear
    echo -e "${COLORS[BG_PURPLE]}${COLORS[BRIGHT_WHITE]}"
    echo "╔══════════════════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                                      ║"
    echo "║                   ${ICONS[ROCKET]} HR STORE VMESS MANAGEMENT PANEL ${ICONS[ROCKET]}                   ║"
    echo "║                                                                                      ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${COLORS[RESET]}"
    echo
}

print_menu() {
    echo -e "${COLORS[BRIGHT_PURPLE]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[GEAR]} VMESS MANAGEMENT MENU${COLORS[RESET]}                                                   ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}                                                                                      ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}01${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[PLUS]} Create VMESS Account${COLORS[RESET]}         ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}06${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[CHART]} Traffic Statistics${COLORS[RESET]}           ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}02${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[USERS]} List All Users${COLORS[RESET]}              ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}07${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[QR]} Generate QR Code${COLORS[RESET]}             ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}03${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[EDIT]} Extend User Expiry${COLORS[RESET]}          ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}08${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[LINK]} Show Config Link${COLORS[RESET]}             ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}04${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[DELETE]} Delete User${COLORS[RESET]}                 ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}09${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[GEAR]} VMESS Configuration${COLORS[RESET]}          ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}05${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[CLOCK]} Check User Status${COLORS[RESET]}           ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}10${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[SHIELD]} Security Settings${COLORS[RESET]}            ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}                                                                                      ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_RED]}[${COLORS[BRIGHT_WHITE]}00${COLORS[BRIGHT_RED]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[BACK]} Back to Main Menu${COLORS[RESET]}           ${COLORS[BRIGHT_RED]}[${COLORS[BRIGHT_WHITE]}99${COLORS[BRIGHT_RED]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[HOME]} Exit${COLORS[RESET]}                         ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}                                                                                      ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
}

# VMESS user management functions
create_vmess_user() {
    clear
    print_header
    
    echo -e "${COLORS[BRIGHT_GREEN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[PLUS]} CREATE NEW VMESS ACCOUNT${COLORS[RESET]}                                                ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
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
    
    # Check if user already exists
    if grep -q "\"email\": \"$username\"" "$XRAY_CONFIG" 2>/dev/null; then
        echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} User '$username' already exists!${COLORS[RESET]}"
        sleep 2
        return
    fi
    
    # Get expiry days
    echo -ne "${COLORS[BRIGHT_CYAN]}${ICONS[CLOCK]} Enter expiry days (default: 30): ${COLORS[RESET]}"
    read -r expiry_days
    expiry_days=${expiry_days:-30}
    
    # Generate UUID
    local uuid=$(generate_uuid)
    local expiry_date=$(date -d "+$expiry_days days" '+%Y-%m-%d')
    
    echo
    echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Creating VMESS account with the following details:${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}Username: ${COLORS[BRIGHT_WHITE]}$username${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}UUID: ${COLORS[BRIGHT_WHITE]}$uuid${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}Expiry Date: ${COLORS[BRIGHT_WHITE]}$expiry_date${COLORS[RESET]}"
    echo
    
    echo -ne "${COLORS[BRIGHT_CYAN]}${ICONS[WARNING]} Proceed with creation? [y/N]: ${COLORS[RESET]}"
    read -r confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        # Save user data
        echo "$username:$uuid:$expiry_date:$(date '+%Y-%m-%d %H:%M:%S')" >> "$VMESS_DATA_DIR/users.txt"
        
        # Log action
        log_action "VMESS user created: $username (UUID: $uuid, expires: $expiry_date)"
        
        echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[CHECK]} VMESS account created successfully!${COLORS[RESET]}"
        
        # Generate VMESS link
        local vmess_config=$(cat << EOF
{
  "v": "2",
  "ps": "HR-STORE-$username",
  "add": "$DOMAIN",
  "port": "443",
  "id": "$uuid",
  "aid": "0",
  "scy": "auto",
  "net": "ws",
  "type": "none",
  "host": "$DOMAIN",
  "path": "/vmess",
  "tls": "tls",
  "sni": "$DOMAIN",
  "alpn": ""
}
EOF
)
        
        local vmess_link="vmess://$(echo -n "$vmess_config" | base64 -w 0)"
        
        # Display connection info
        echo
        echo -e "${COLORS[BRIGHT_CYAN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[INFO]} VMESS CONNECTION INFORMATION${COLORS[RESET]}                                          ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}Server${COLORS[RESET]}     : ${COLORS[BRIGHT_WHITE]}$DOMAIN${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}Port${COLORS[RESET]}       : ${COLORS[BRIGHT_WHITE]}443${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}UUID${COLORS[RESET]}       : ${COLORS[BRIGHT_WHITE]}$uuid${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}Security${COLORS[RESET]}   : ${COLORS[BRIGHT_WHITE]}auto${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}Network${COLORS[RESET]}    : ${COLORS[BRIGHT_WHITE]}ws${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}Path${COLORS[RESET]}       : ${COLORS[BRIGHT_WHITE]}/vmess${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}TLS${COLORS[RESET]}        : ${COLORS[BRIGHT_WHITE]}tls${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}Expires${COLORS[RESET]}    : ${COLORS[BRIGHT_WHITE]}$expiry_date${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}VMESS Link:${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BRIGHT_GREEN]}$vmess_link${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
        
        # Save config to file
        echo "$vmess_link" > "$VMESS_DATA_DIR/$username.txt"
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Configuration saved to: $VMESS_DATA_DIR/$username.txt${COLORS[RESET]}"
        
    else
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Account creation cancelled.${COLORS[RESET]}"
    fi
    
    echo
    echo -ne "${COLORS[BRIGHT_CYAN]}Press Enter to continue...${COLORS[RESET]}"
    read
}

list_vmess_users() {
    clear
    print_header
    
    echo -e "${COLORS[BRIGHT_GREEN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[USERS]} VMESS USERS LIST${COLORS[RESET]}                                                        ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
    
    if [[ ! -f "$VMESS_DATA_DIR/users.txt" ]]; then
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} No VMESS users found.${COLORS[RESET]}"
    else
        echo -e "${COLORS[BRIGHT_CYAN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BOLD]}Username${COLORS[RESET]}     ${COLORS[BOLD]}UUID${COLORS[RESET]}                                 ${COLORS[BOLD]}Expiry Date${COLORS[RESET]}    ${COLORS[BOLD]}Created${COLORS[RESET]}          ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
        
        local user_count=0
        while IFS=: read -r username uuid expiry_date created; do
            if [[ -n "$username" ]]; then
                ((user_count++))
                
                # Check if expired
                local status="${COLORS[BRIGHT_GREEN]}Active${COLORS[RESET]}"
                if [[ $(date -d "$expiry_date" +%s) -lt $(date +%s) ]]; then
                    status="${COLORS[BRIGHT_RED]}Expired${COLORS[RESET]}"
                fi
                
                # Truncate UUID for display
                local short_uuid="${uuid:0:8}...${uuid: -8}"
                
                printf "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} %-12s %-32s %-15s %-16s ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}\n" \
                    "$username" "$short_uuid" "$expiry_date" "$created"
            fi
        done < "$VMESS_DATA_DIR/users.txt"
        
        echo -e "${COLORS[BRIGHT_CYAN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
        echo
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Total VMESS users: ${COLORS[BRIGHT_WHITE]}$user_count${COLORS[RESET]}"
    fi
    
    echo
    echo -ne "${COLORS[BRIGHT_CYAN]}Press Enter to continue...${COLORS[RESET]}"
    read
}

delete_vmess_user() {
    clear
    print_header
    
    echo -e "${COLORS[BRIGHT_RED]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_RED]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[DELETE]} DELETE VMESS USER${COLORS[RESET]}                                                       ${COLORS[BRIGHT_RED]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_RED]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
    
    if [[ ! -f "$VMESS_DATA_DIR/users.txt" ]]; then
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} No VMESS users found to delete.${COLORS[RESET]}"
        echo -ne "${COLORS[BRIGHT_CYAN]}Press Enter to continue...${COLORS[RESET]}"
        read
        return
    fi
    
    # List current users
    echo -e "${COLORS[BRIGHT_CYAN]}${ICONS[USERS]} Current VMESS users:${COLORS[RESET]}"
    while IFS=: read -r username uuid expiry_date created; do
        if [[ -n "$username" ]]; then
            echo -e "  ${COLORS[BRIGHT_WHITE]}• $username${COLORS[RESET]} (expires: $expiry_date)"
        fi
    done < "$VMESS_DATA_DIR/users.txt"
    
    echo
    echo -ne "${COLORS[BRIGHT_CYAN]}${ICONS[USER]} Enter username to delete: ${COLORS[RESET]}"
    read -r username
    
    if [[ -z "$username" ]]; then
        echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} Username cannot be empty!${COLORS[RESET]}"
        sleep 2
        return
    fi
    
    if ! grep -q "^$username:" "$VMESS_DATA_DIR/users.txt"; then
        echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} User '$username' does not exist!${COLORS[RESET]}"
        sleep 2
        return
    fi
    
    echo
    echo -e "${COLORS[BRIGHT_RED]}${ICONS[WARNING]} WARNING: This will permanently delete the VMESS user '$username'!${COLORS[RESET]}"
    echo -ne "${COLORS[BRIGHT_CYAN]}${ICONS[WARNING]} Are you sure? Type 'DELETE' to confirm: ${COLORS[RESET]}"
    read -r confirm
    
    if [[ "$confirm" == "DELETE" ]]; then
        # Remove from user data file
        sed -i "/^$username:/d" "$VMESS_DATA_DIR/users.txt"
        
        # Remove config file
        rm -f "$VMESS_DATA_DIR/$username.txt"
        
        log_action "VMESS user deleted: $username"
        echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[CHECK]} User '$username' deleted successfully!${COLORS[RESET]}"
    else
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} User deletion cancelled.${COLORS[RESET]}"
    fi
    
    echo
    echo -ne "${COLORS[BRIGHT_CYAN]}Press Enter to continue...${COLORS[RESET]}"
    read
}

show_config_link() {
    clear
    print_header
    
    echo -e "${COLORS[BRIGHT_GREEN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[LINK]} SHOW VMESS CONFIG LINK${COLORS[RESET]}                                                 ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
    
    if [[ ! -f "$VMESS_DATA_DIR/users.txt" ]]; then
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} No VMESS users found.${COLORS[RESET]}"
        echo -ne "${COLORS[BRIGHT_CYAN]}Press Enter to continue...${COLORS[RESET]}"
        read
        return
    fi
    
    # List current users
    echo -e "${COLORS[BRIGHT_CYAN]}${ICONS[USERS]} Available VMESS users:${COLORS[RESET]}"
    while IFS=: read -r username uuid expiry_date created; do
        if [[ -n "$username" ]]; then
            echo -e "  ${COLORS[BRIGHT_WHITE]}• $username${COLORS[RESET]}"
        fi
    done < "$VMESS_DATA_DIR/users.txt"
    
    echo
    echo -ne "${COLORS[BRIGHT_CYAN]}${ICONS[USER]} Enter username: ${COLORS[RESET]}"
    read -r username
    
    if [[ -z "$username" ]]; then
        echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} Username cannot be empty!${COLORS[RESET]}"
        sleep 2
        return
    fi
    
    if [[ -f "$VMESS_DATA_DIR/$username.txt" ]]; then
        local vmess_link=$(cat "$VMESS_DATA_DIR/$username.txt")
        
        echo
        echo -e "${COLORS[BRIGHT_CYAN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}VMESS Configuration for: $username${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BRIGHT_GREEN]}$vmess_link${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
        
        echo
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Copy the link above and import it into your VMESS client.${COLORS[RESET]}"
    else
        echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} Configuration file not found for user '$username'!${COLORS[RESET]}"
    fi
    
    echo
    echo -ne "${COLORS[BRIGHT_CYAN]}Press Enter to continue...${COLORS[RESET]}"
    read
}

# Main menu handler
handle_vmess_menu() {
    while true; do
        clear
        print_header
        print_menu
        
        echo -ne "${COLORS[BRIGHT_CYAN]}┌─[${COLORS[BRIGHT_WHITE]}HR-STORE-VMESS${COLORS[BRIGHT_CYAN]}]─[${COLORS[BRIGHT_YELLOW]}$(whoami)${COLORS[BRIGHT_CYAN]}]─[${COLORS[BRIGHT_WHITE]}$(date +%H:%M:%S)${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]}\n"
        echo -ne "${COLORS[BRIGHT_CYAN]}└─${COLORS[BRIGHT_WHITE]}Select Option${COLORS[BRIGHT_CYAN]}: ${COLORS[RESET]}"
        read -r choice
        
        case $choice in
            1|01) create_vmess_user ;;
            2|02) list_vmess_users ;;
            3|03) echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Feature coming soon!${COLORS[RESET]}"; sleep 2 ;;
            4|04) delete_vmess_user ;;
            5|05) echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Feature coming soon!${COLORS[RESET]}"; sleep 2 ;;
            6|06) echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Feature coming soon!${COLORS[RESET]}"; sleep 2 ;;
            7|07) echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Feature coming soon!${COLORS[RESET]}"; sleep 2 ;;
            8|08) show_config_link ;;
            9|09) echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Feature coming soon!${COLORS[RESET]}"; sleep 2 ;;
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
    handle_vmess_menu
fi

