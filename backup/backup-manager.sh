#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════════
# HR STORE Backup Manager Utility
# Version: 6.0 Enhanced
# Author: HR STORE Team
# Description: Advanced backup and restore system with encryption
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
    [BACKUP]="💾"
    [RESTORE]="📥"
    [DOWNLOAD]="⬇️"
    [UPLOAD]="⬆️"
    [FOLDER]="📁"
    [FILE]="📄"
    [LOCK]="🔒"
    [UNLOCK]="🔓"
    [CHECK]="✅"
    [CROSS]="❌"
    [WARNING]="⚠️"
    [INFO]="ℹ️"
    [CLOCK]="🕐"
    [GEAR]="⚙️"
    [SHIELD]="🛡️"
    [BACK]="⬅️"
    [CLOUD]="☁️"
    [COMPRESS]="🗜️"
)

# Configuration
BACKUP_DIR="/root/hrstore-backups"
CONFIG_DIRS=("/etc/xray" "/etc/nginx" "/etc/stunnel" "/etc/ssh" "/usr/local/hrstore")
USER_DATA_DIRS=("/usr/local/hrstore/data")
LOG_FILE="/var/log/hrstore/backup-manager.log"

# Ensure directories exist
mkdir -p "$BACKUP_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

# Logging function
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Utility functions
generate_backup_name() {
    echo "hrstore-backup-$(date '+%Y%m%d-%H%M%S')"
}

get_backup_size() {
    local backup_path="$1"
    if [[ -f "$backup_path" ]]; then
        du -h "$backup_path" | cut -f1
    else
        echo "N/A"
    fi
}

# Display functions
print_header() {
    clear
    echo -e "${COLORS[BG_PURPLE]}${COLORS[BRIGHT_WHITE]}"
    echo "╔══════════════════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                                      ║"
    echo "║                   ${ICONS[BACKUP]} HR STORE BACKUP MANAGER ${ICONS[BACKUP]}                           ║"
    echo "║                                                                                      ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${COLORS[RESET]}"
    echo
}

print_menu() {
    echo -e "${COLORS[BRIGHT_PURPLE]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[GEAR]} BACKUP MANAGEMENT MENU${COLORS[RESET]}                                                 ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}                                                                                      ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}01${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[BACKUP]} Create Full Backup${COLORS[RESET]}           ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}06${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[CLOUD]} Cloud Backup${COLORS[RESET]}                 ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}02${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[RESTORE]} Restore from Backup${COLORS[RESET]}         ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}07${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[GEAR]} Backup Settings${COLORS[RESET]}              ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}03${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[FOLDER]} List Backups${COLORS[RESET]}                ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}08${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[CLOCK]} Scheduled Backups${COLORS[RESET]}            ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}04${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[COMPRESS]} Compress Backup${COLORS[RESET]}             ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}09${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[DOWNLOAD]} Export Backup${COLORS[RESET]}                ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}05${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[CROSS]} Delete Backup${COLORS[RESET]}               ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}10${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[UPLOAD]} Import Backup${COLORS[RESET]}                ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}                                                                                      ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_RED]}[${COLORS[BRIGHT_WHITE]}00${COLORS[BRIGHT_RED]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[BACK]} Back to Main Menu${COLORS[RESET]}           ${COLORS[BRIGHT_RED]}[${COLORS[BRIGHT_WHITE]}99${COLORS[BRIGHT_RED]}]${COLORS[RESET]} ${COLORS[WHITE]}Exit${COLORS[RESET]}                         ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}                                                                                      ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
}

# Backup functions
create_full_backup() {
    clear
    print_header
    
    echo -e "${COLORS[BRIGHT_GREEN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[BACKUP]} CREATE FULL BACKUP${COLORS[RESET]}                                                     ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
    
    local backup_name=$(generate_backup_name)
    local backup_path="$BACKUP_DIR/$backup_name"
    
    echo -e "${COLORS[BRIGHT_CYAN]}${ICONS[INFO]} Backup will be created as: ${COLORS[BRIGHT_WHITE]}$backup_name${COLORS[RESET]}"
    echo
    
    # Ask for encryption
    echo -ne "${COLORS[BRIGHT_CYAN]}${ICONS[LOCK]} Enable encryption? [y/N]: ${COLORS[RESET]}"
    read -r encrypt_choice
    
    local encrypt_flag=""
    local password=""
    if [[ "$encrypt_choice" =~ ^[Yy]$ ]]; then
        echo -ne "${COLORS[BRIGHT_CYAN]}${ICONS[KEY]} Enter encryption password: ${COLORS[RESET]}"
        read -s password
        echo
        encrypt_flag="--password=$password"
    fi
    
    echo
    echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[WARNING]} This will backup the following:${COLORS[RESET]}"
    echo -e "  ${COLORS[CYAN]}• Configuration files${COLORS[RESET]}"
    echo -e "  ${COLORS[CYAN]}• User data${COLORS[RESET]}"
    echo -e "  ${COLORS[CYAN]}• System settings${COLORS[RESET]}"
    echo -e "  ${COLORS[CYAN]}• VPN configurations${COLORS[RESET]}"
    echo
    
    echo -ne "${COLORS[BRIGHT_CYAN]}${ICONS[WARNING]} Proceed with backup creation? [y/N]: ${COLORS[RESET]}"
    read -r confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo
        echo -e "${COLORS[BRIGHT_CYAN]}${ICONS[BACKUP]} Creating backup...${COLORS[RESET]}"
        
        # Create temporary directory
        local temp_dir="/tmp/hrstore-backup-$$"
        mkdir -p "$temp_dir"
        
        # Progress tracking
        local total_steps=6
        local current_step=0
        
        # Step 1: Backup configurations
        ((current_step++))
        echo -e "${COLORS[BRIGHT_CYAN]}[$current_step/$total_steps] ${ICONS[GEAR]} Backing up configurations...${COLORS[RESET]}"
        
        for config_dir in "${CONFIG_DIRS[@]}"; do
            if [[ -d "$config_dir" ]]; then
                local dir_name=$(basename "$config_dir")
                cp -r "$config_dir" "$temp_dir/$dir_name" 2>/dev/null
                echo -e "  ${COLORS[GREEN]}${ICONS[CHECK]} $config_dir${COLORS[RESET]}"
            fi
        done
        
        # Step 2: Backup user data
        ((current_step++))
        echo -e "${COLORS[BRIGHT_CYAN]}[$current_step/$total_steps] ${ICONS[FOLDER]} Backing up user data...${COLORS[RESET]}"
        
        for data_dir in "${USER_DATA_DIRS[@]}"; do
            if [[ -d "$data_dir" ]]; then
                local dir_name=$(basename "$data_dir")
                cp -r "$data_dir" "$temp_dir/$dir_name" 2>/dev/null
                echo -e "  ${COLORS[GREEN]}${ICONS[CHECK]} $data_dir${COLORS[RESET]}"
            fi
        done
        
        # Step 3: Backup system info
        ((current_step++))
        echo -e "${COLORS[BRIGHT_CYAN]}[$current_step/$total_steps] ${ICONS[INFO]} Collecting system information...${COLORS[RESET]}"
        
        cat > "$temp_dir/system-info.txt" << EOF
# HR STORE Backup Information
Backup Date: $(date '+%Y-%m-%d %H:%M:%S')
Hostname: $(hostname)
OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)
Kernel: $(uname -r)
IP Address: $(curl -s ipv4.icanhazip.com 2>/dev/null || echo "Unknown")
HR STORE Version: 6.0 Enhanced
EOF
        
        # Step 4: Create package list
        ((current_step++))
        echo -e "${COLORS[BRIGHT_CYAN]}[$current_step/$total_steps] ${ICONS[GEAR]} Creating package list...${COLORS[RESET]}"
        
        if command -v dpkg &>/dev/null; then
            dpkg --get-selections > "$temp_dir/packages.txt"
        elif command -v rpm &>/dev/null; then
            rpm -qa > "$temp_dir/packages.txt"
        fi
        
        # Step 5: Create archive
        ((current_step++))
        echo -e "${COLORS[BRIGHT_CYAN]}[$current_step/$total_steps] ${ICONS[COMPRESS]} Creating archive...${COLORS[RESET]}"
        
        cd "$temp_dir" || exit 1
        if [[ -n "$encrypt_flag" ]]; then
            tar -czf - . | gpg --symmetric --cipher-algo AES256 --compress-algo 1 --s2k-mode 3 --s2k-digest-algo SHA512 --s2k-count 65536 --force-mdc --passphrase "$password" --batch --quiet > "$backup_path.tar.gz.gpg"
        else
            tar -czf "$backup_path.tar.gz" .
        fi
        
        # Step 6: Cleanup and verify
        ((current_step++))
        echo -e "${COLORS[BRIGHT_CYAN]}[$current_step/$total_steps] ${ICONS[CHECK]} Finalizing backup...${COLORS[RESET]}"
        
        cd - > /dev/null
        rm -rf "$temp_dir"
        
        # Verify backup
        local backup_file="$backup_path.tar.gz"
        [[ -n "$encrypt_flag" ]] && backup_file="$backup_path.tar.gz.gpg"
        
        if [[ -f "$backup_file" ]]; then
            local backup_size=$(get_backup_size "$backup_file")
            
            # Save backup metadata
            cat > "$backup_path.info" << EOF
name=$backup_name
date=$(date '+%Y-%m-%d %H:%M:%S')
size=$backup_size
encrypted=$([[ -n "$encrypt_flag" ]] && echo "yes" || echo "no")
version=6.0
EOF
            
            log_action "Full backup created: $backup_name (size: $backup_size)"
            
            echo
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[CHECK]} Backup created successfully!${COLORS[RESET]}"
            echo
            echo -e "${COLORS[BRIGHT_CYAN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
            echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}BACKUP INFORMATION${COLORS[RESET]}"
            echo -e "${COLORS[BRIGHT_CYAN]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
            echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}Name${COLORS[RESET]}       : ${COLORS[BRIGHT_WHITE]}$backup_name${COLORS[RESET]}"
            echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}Size${COLORS[RESET]}       : ${COLORS[BRIGHT_WHITE]}$backup_size${COLORS[RESET]}"
            echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}Location${COLORS[RESET]}   : ${COLORS[BRIGHT_WHITE]}$backup_file${COLORS[RESET]}"
            echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}Encrypted${COLORS[RESET]}  : ${COLORS[BRIGHT_WHITE]}$([[ -n "$encrypt_flag" ]] && echo "Yes" || echo "No")${COLORS[RESET]}"
            echo -e "${COLORS[BRIGHT_CYAN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
        else
            echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} Backup creation failed!${COLORS[RESET]}"
            log_action "Failed to create backup: $backup_name"
        fi
    else
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Backup creation cancelled.${COLORS[RESET]}"
    fi
    
    echo
    echo -ne "${COLORS[BRIGHT_CYAN]}Press Enter to continue...${COLORS[RESET]}"
    read
}

list_backups() {
    clear
    print_header
    
    echo -e "${COLORS[BRIGHT_GREEN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[FOLDER]} AVAILABLE BACKUPS${COLORS[RESET]}                                                     ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
    
    local backup_count=0
    
    if [[ -d "$BACKUP_DIR" ]] && [[ -n "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]]; then
        echo -e "${COLORS[BRIGHT_CYAN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BOLD]}Backup Name${COLORS[RESET]}                    ${COLORS[BOLD]}Date${COLORS[RESET]}              ${COLORS[BOLD]}Size${COLORS[RESET]}     ${COLORS[BOLD]}Encrypted${COLORS[RESET]}  ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
        
        for info_file in "$BACKUP_DIR"/*.info; do
            if [[ -f "$info_file" ]]; then
                ((backup_count++))
                
                # Read backup metadata
                local name=$(grep "^name=" "$info_file" | cut -d'=' -f2)
                local date=$(grep "^date=" "$info_file" | cut -d'=' -f2)
                local size=$(grep "^size=" "$info_file" | cut -d'=' -f2)
                local encrypted=$(grep "^encrypted=" "$info_file" | cut -d'=' -f2)
                
                local encrypt_icon="${COLORS[BRIGHT_RED]}${ICONS[UNLOCK]}${COLORS[RESET]}"
                [[ "$encrypted" == "yes" ]] && encrypt_icon="${COLORS[BRIGHT_GREEN]}${ICONS[LOCK]}${COLORS[RESET]}"
                
                printf "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} %-30s %-16s %-8s %s        ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}\n" \
                    "$name" "$date" "$size" "$encrypt_icon"
            fi
        done
        
        echo -e "${COLORS[BRIGHT_CYAN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
        echo
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Total backups: ${COLORS[BRIGHT_WHITE]}$backup_count${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[FOLDER]} Backup directory: ${COLORS[BRIGHT_WHITE]}$BACKUP_DIR${COLORS[RESET]}"
        
        # Calculate total backup size
        local total_size=$(du -sh "$BACKUP_DIR" 2>/dev/null | cut -f1)
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[COMPRESS]} Total size: ${COLORS[BRIGHT_WHITE]}$total_size${COLORS[RESET]}"
    else
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} No backups found.${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}${ICONS[BACKUP]} Create your first backup using option 1.${COLORS[RESET]}"
    fi
    
    echo
    echo -ne "${COLORS[BRIGHT_CYAN]}Press Enter to continue...${COLORS[RESET]}"
    read
}

delete_backup() {
    clear
    print_header
    
    echo -e "${COLORS[BRIGHT_RED]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_RED]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[CROSS]} DELETE BACKUP${COLORS[RESET]}                                                           ${COLORS[BRIGHT_RED]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_RED]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
    
    # List available backups
    echo -e "${COLORS[BRIGHT_CYAN]}${ICONS[FOLDER]} Available backups:${COLORS[RESET]}"
    local backup_names=()
    
    for info_file in "$BACKUP_DIR"/*.info; do
        if [[ -f "$info_file" ]]; then
            local name=$(grep "^name=" "$info_file" | cut -d'=' -f2)
            local date=$(grep "^date=" "$info_file" | cut -d'=' -f2)
            backup_names+=("$name")
            echo -e "  ${COLORS[BRIGHT_WHITE]}• $name${COLORS[RESET]} ($date)"
        fi
    done
    
    if [[ ${#backup_names[@]} -eq 0 ]]; then
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} No backups found to delete.${COLORS[RESET]}"
        echo -ne "${COLORS[BRIGHT_CYAN]}Press Enter to continue...${COLORS[RESET]}"
        read
        return
    fi
    
    echo
    echo -ne "${COLORS[BRIGHT_CYAN]}${ICONS[CROSS]} Enter backup name to delete: ${COLORS[RESET]}"
    read -r backup_name
    
    if [[ -z "$backup_name" ]]; then
        echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} Backup name cannot be empty!${COLORS[RESET]}"
        sleep 2
        return
    fi
    
    # Check if backup exists
    if [[ ! -f "$BACKUP_DIR/$backup_name.info" ]]; then
        echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} Backup '$backup_name' does not exist!${COLORS[RESET]}"
        sleep 2
        return
    fi
    
    echo
    echo -e "${COLORS[BRIGHT_RED]}${ICONS[WARNING]} WARNING: This will permanently delete the backup '$backup_name'!${COLORS[RESET]}"
    echo -ne "${COLORS[BRIGHT_CYAN]}${ICONS[WARNING]} Are you sure? Type 'DELETE' to confirm: ${COLORS[RESET]}"
    read -r confirm
    
    if [[ "$confirm" == "DELETE" ]]; then
        # Delete backup files
        rm -f "$BACKUP_DIR/$backup_name"*
        
        log_action "Backup deleted: $backup_name"
        echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[CHECK]} Backup '$backup_name' deleted successfully!${COLORS[RESET]}"
    else
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Backup deletion cancelled.${COLORS[RESET]}"
    fi
    
    echo
    echo -ne "${COLORS[BRIGHT_CYAN]}Press Enter to continue...${COLORS[RESET]}"
    read
}

# Main menu handler
handle_backup_menu() {
    while true; do
        clear
        print_header
        print_menu
        
        echo -ne "${COLORS[BRIGHT_CYAN]}┌─[${COLORS[BRIGHT_WHITE]}HR-STORE-BACKUP${COLORS[BRIGHT_CYAN]}]─[${COLORS[BRIGHT_YELLOW]}$(whoami)${COLORS[BRIGHT_CYAN]}]─[${COLORS[BRIGHT_WHITE]}$(date +%H:%M:%S)${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]}\n"
        echo -ne "${COLORS[BRIGHT_CYAN]}└─${COLORS[BRIGHT_WHITE]}Select Option${COLORS[BRIGHT_CYAN]}: ${COLORS[RESET]}"
        read -r choice
        
        case $choice in
            1|01) create_full_backup ;;
            2|02) echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Restore feature coming soon!${COLORS[RESET]}"; sleep 2 ;;
            3|03) list_backups ;;
            4|04) echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Compress feature coming soon!${COLORS[RESET]}"; sleep 2 ;;
            5|05) delete_backup ;;
            6|06) echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Cloud backup feature coming soon!${COLORS[RESET]}"; sleep 2 ;;
            7|07) echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Settings feature coming soon!${COLORS[RESET]}"; sleep 2 ;;
            8|08) echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Scheduled backup feature coming soon!${COLORS[RESET]}"; sleep 2 ;;
            9|09) echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Export feature coming soon!${COLORS[RESET]}"; sleep 2 ;;
            10) echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Import feature coming soon!${COLORS[RESET]}"; sleep 2 ;;
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
    handle_backup_menu
fi

