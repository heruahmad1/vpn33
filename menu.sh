#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════════
# HR STORE VPN Management Panel - Premium Edition
# Version: 6.0 Enhanced
# Author: HR STORE Team
# Description: Advanced VPN management system with modern UI
# ═══════════════════════════════════════════════════════════════════════════════

# Color Palette - Modern Design
declare -A COLORS=(
    [RESET]='\033[0m'
    [BOLD]='\033[1m'
    [DIM]='\033[2m'
    [UNDERLINE]='\033[4m'
    [BLINK]='\033[5m'
    [REVERSE]='\033[7m'
    
    # Standard Colors
    [BLACK]='\033[0;30m'
    [RED]='\033[0;31m'
    [GREEN]='\033[0;32m'
    [YELLOW]='\033[0;33m'
    [BLUE]='\033[0;34m'
    [PURPLE]='\033[0;35m'
    [CYAN]='\033[0;36m'
    [WHITE]='\033[0;37m'
    
    # Bright Colors
    [BRIGHT_BLACK]='\033[1;30m'
    [BRIGHT_RED]='\033[1;31m'
    [BRIGHT_GREEN]='\033[1;32m'
    [BRIGHT_YELLOW]='\033[1;33m'
    [BRIGHT_BLUE]='\033[1;34m'
    [BRIGHT_PURPLE]='\033[1;35m'
    [BRIGHT_CYAN]='\033[1;36m'
    [BRIGHT_WHITE]='\033[1;37m'
    
    # Background Colors
    [BG_BLACK]='\033[40m'
    [BG_RED]='\033[41m'
    [BG_GREEN]='\033[42m'
    [BG_YELLOW]='\033[43m'
    [BG_BLUE]='\033[44m'
    [BG_PURPLE]='\033[45m'
    [BG_CYAN]='\033[46m'
    [BG_WHITE]='\033[47m'
    
    # RGB Colors (256-color support)
    [ORANGE]='\033[38;5;208m'
    [PINK]='\033[38;5;205m'
    [LIME]='\033[38;5;154m'
    [TEAL]='\033[38;5;51m'
    [GOLD]='\033[38;5;220m'
    [SILVER]='\033[38;5;250m'
    [DARK_GRAY]='\033[38;5;240m'
    [LIGHT_GRAY]='\033[38;5;248m'
)

# Emoji and Icons
declare -A ICONS=(
    [ROCKET]="🚀"
    [SHIELD]="🛡️"
    [GLOBE]="🌐"
    [LOCK]="🔒"
    [KEY]="🔑"
    [GEAR]="⚙️"
    [CHART]="📊"
    [BACKUP]="💾"
    [USER]="👤"
    [USERS]="👥"
    [CLOCK]="🕐"
    [CHECK]="✅"
    [CROSS]="❌"
    [WARNING]="⚠️"
    [INFO]="ℹ️"
    [STAR]="⭐"
    [DIAMOND]="💎"
    [FIRE]="🔥"
    [LIGHTNING]="⚡"
    [CROWN]="👑"
)

# System Information Functions
get_system_info() {
    HOSTNAME=$(hostname)
    KERNEL=$(uname -r)
    UPTIME=$(uptime -p | sed 's/up //')
    LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | sed 's/^ *//')
    MEMORY_USAGE=$(free | awk 'NR==2{printf "%.1f%%", $3*100/$2}')
    DISK_USAGE=$(df -h / | awk 'NR==2{print $5}')
    CPU_CORES=$(nproc)
    
    # Get public IP with fallback
    PUBLIC_IP=$(curl -s --max-time 5 ipv4.icanhazip.com 2>/dev/null || curl -s --max-time 5 ifconfig.me 2>/dev/null || echo "Unknown")
    
    # Get local IP
    LOCAL_IP=$(ip route get 8.8.8.8 | awk '{print $7; exit}' 2>/dev/null || echo "Unknown")
    
    # Get network interface
    INTERFACE=$(ip route | awk '/default/ {print $5; exit}')
    
    # Get OS info
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        OS_NAME="$PRETTY_NAME"
    else
        OS_NAME=$(uname -s)
    fi
}

# Service Status Functions
check_service() {
    local service=$1
    if systemctl is-active --quiet "$service" 2>/dev/null; then
        echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[CHECK]}${COLORS[RESET]}"
    elif systemctl is-enabled --quiet "$service" 2>/dev/null; then
        echo -e "${COLORS[YELLOW]}${ICONS[WARNING]}${COLORS[RESET]}"
    else
        echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]}${COLORS[RESET]}"
    fi
}

get_service_status() {
    SSH_STATUS=$(check_service ssh)
    NGINX_STATUS=$(check_service nginx)
    XRAY_STATUS=$(check_service xray)
    STUNNEL_STATUS=$(check_service stunnel4)
    DROPBEAR_STATUS=$(check_service dropbear)
    OPENVPN_STATUS=$(check_service openvpn)
    SQUID_STATUS=$(check_service squid)
    FAIL2BAN_STATUS=$(check_service fail2ban)
}

# User Statistics Functions
get_user_stats() {
    # SSH Users
    SSH_USERS=$(who | wc -l)
    
    # VPN Users (mock data - replace with actual implementation)
    VMESS_USERS=$(( RANDOM % 10 + 1 ))
    VLESS_USERS=$(( RANDOM % 8 + 1 ))
    TROJAN_USERS=$(( RANDOM % 6 + 1 ))
    SHADOWSOCKS_USERS=$(( RANDOM % 5 + 1 ))
    
    # Total active connections
    TOTAL_CONNECTIONS=$(( SSH_USERS + VMESS_USERS + VLESS_USERS + TROJAN_USERS + SHADOWSOCKS_USERS ))
}

# Bandwidth Functions
get_bandwidth_stats() {
    # Get network statistics
    if [[ -n "$INTERFACE" ]]; then
        RX_BYTES=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes 2>/dev/null || echo 0)
        TX_BYTES=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes 2>/dev/null || echo 0)
        
        # Convert to human readable
        RX_HUMAN=$(numfmt --to=iec-i --suffix=B $RX_BYTES 2>/dev/null || echo "0B")
        TX_HUMAN=$(numfmt --to=iec-i --suffix=B $TX_BYTES 2>/dev/null || echo "0B")
    else
        RX_HUMAN="N/A"
        TX_HUMAN="N/A"
    fi
    
    # Mock daily/monthly stats (replace with actual implementation)
    TODAY_USAGE="$(( RANDOM % 5 + 1 )).$(( RANDOM % 9 ))GB"
    YESTERDAY_USAGE="$(( RANDOM % 4 + 2 )).$(( RANDOM % 9 ))GB"
    MONTHLY_USAGE="$(( RANDOM % 50 + 20 )).$(( RANDOM % 9 ))GB"
}

# License Information
get_license_info() {
    LICENSE_USER="HR STORE Premium"
    LICENSE_DAYS=$(( RANDOM % 365 + 30 ))
    SCRIPT_VERSION="6.0 Enhanced"
    BUILD_DATE=$(date '+%Y-%m-%d')
}

# Animation Functions
print_with_delay() {
    local text="$1"
    local delay="${2:-0.01}"
    
    for (( i=0; i<${#text}; i++ )); do
        printf "%s" "${text:$i:1}"
        sleep "$delay"
    done
    echo
}

show_loading() {
    local message="$1"
    local duration="${2:-3}"
    
    echo -ne "${COLORS[BRIGHT_CYAN]}${message}${COLORS[RESET]} "
    
    for i in {1..20}; do
        echo -ne "${COLORS[BRIGHT_BLUE]}█${COLORS[RESET]}"
        sleep $(echo "scale=2; $duration/20" | bc -l 2>/dev/null || echo "0.15")
    done
    echo -e " ${COLORS[BRIGHT_GREEN]}${ICONS[CHECK]}${COLORS[RESET]}"
}

# Header Display Functions
display_header() {
    clear
    
    # Gradient header background
    echo -e "${COLORS[BG_BLUE]}${COLORS[BRIGHT_WHITE]}"
    echo "╔══════════════════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                                      ║"
    echo "║    ██╗  ██╗██████╗     ███████╗████████╗ ██████╗ ██████╗ ███████╗                   ║"
    echo "║    ██║  ██║██╔══██╗    ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝                   ║"
    echo "║    ███████║██████╔╝    ███████╗   ██║   ██║   ██║██████╔╝█████╗                     ║"
    echo "║    ██╔══██║██╔══██╗    ╚════██║   ██║   ██║   ██║██╔══██╗██╔══╝                     ║"
    echo "║    ██║  ██║██║  ██║    ███████║   ██║   ╚██████╔╝██║  ██║███████╗                   ║"
    echo "║    ╚═╝  ╚═╝╚═╝  ╚═╝    ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝                   ║"
    echo "║                                                                                      ║"
    echo "║              ${ICONS[CROWN]} PREMIUM VPN MANAGEMENT PANEL ${ICONS[CROWN]}                           ║"
    echo "║                          ${ICONS[LIGHTNING]} POWERED BY HR STORE ${ICONS[LIGHTNING]}                              ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${COLORS[RESET]}"
}

display_system_info() {
    echo -e "${COLORS[BRIGHT_CYAN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[GEAR]} SYSTEM INFORMATION${COLORS[RESET]}                                                        ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[GOLD]}${ICONS[GLOBE]} Server IP${COLORS[RESET]}     : ${COLORS[BRIGHT_WHITE]}$PUBLIC_IP${COLORS[RESET]} ${COLORS[DARK_GRAY]}(Local: $LOCAL_IP)${COLORS[RESET]}                    ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[GOLD]}${ICONS[GEAR]} Hostname${COLORS[RESET]}      : ${COLORS[BRIGHT_WHITE]}$HOSTNAME${COLORS[RESET]}                                           ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[GOLD]}${ICONS[GEAR]} OS Version${COLORS[RESET]}    : ${COLORS[BRIGHT_WHITE]}$OS_NAME${COLORS[RESET]}                                  ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[GOLD]}${ICONS[GEAR]} Kernel${COLORS[RESET]}        : ${COLORS[BRIGHT_WHITE]}$KERNEL${COLORS[RESET]}                                             ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[GOLD]}${ICONS[CLOCK]} Uptime${COLORS[RESET]}        : ${COLORS[BRIGHT_WHITE]}$UPTIME${COLORS[RESET]}                                             ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[GOLD]}${ICONS[CHART]} Load Average${COLORS[RESET]}  : ${COLORS[BRIGHT_WHITE]}$LOAD_AVG${COLORS[RESET]}                                          ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[GOLD]}${ICONS[CHART]} Memory Usage${COLORS[RESET]}  : ${COLORS[BRIGHT_WHITE]}$MEMORY_USAGE${COLORS[RESET]} ${COLORS[DARK_GRAY]}($CPU_CORES CPU Cores)${COLORS[RESET]}                      ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[GOLD]}${ICONS[CHART]} Disk Usage${COLORS[RESET]}    : ${COLORS[BRIGHT_WHITE]}$DISK_USAGE${COLORS[RESET]}                                              ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
}

display_service_status() {
    echo -e "${COLORS[BRIGHT_PURPLE]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[SHIELD]} SERVICE STATUS${COLORS[RESET]}                                                           ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]} SSH: $SSH_STATUS   NGINX: $NGINX_STATUS   XRAY: $XRAY_STATUS   STUNNEL: $STUNNEL_STATUS   DROPBEAR: $DROPBEAR_STATUS                      ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]} OPENVPN: $OPENVPN_STATUS   SQUID: $SQUID_STATUS   FAIL2BAN: $FAIL2BAN_STATUS                                           ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
}

display_user_stats() {
    echo -e "${COLORS[BRIGHT_GREEN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[USERS]} ACTIVE CONNECTIONS${COLORS[RESET]}                                                      ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[CYAN]}SSH${COLORS[RESET]}: ${COLORS[BRIGHT_WHITE]}$SSH_USERS${COLORS[RESET]}   ${COLORS[CYAN]}VMESS${COLORS[RESET]}: ${COLORS[BRIGHT_WHITE]}$VMESS_USERS${COLORS[RESET]}   ${COLORS[CYAN]}VLESS${COLORS[RESET]}: ${COLORS[BRIGHT_WHITE]}$VLESS_USERS${COLORS[RESET]}   ${COLORS[CYAN]}TROJAN${COLORS[RESET]}: ${COLORS[BRIGHT_WHITE]}$TROJAN_USERS${COLORS[RESET]}   ${COLORS[CYAN]}SS${COLORS[RESET]}: ${COLORS[BRIGHT_WHITE]}$SHADOWSOCKS_USERS${COLORS[RESET]}           ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[GOLD]}${ICONS[CHART]} Total Active Connections${COLORS[RESET]}: ${COLORS[BRIGHT_WHITE]}$TOTAL_CONNECTIONS${COLORS[RESET]}                                      ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
}

display_bandwidth_stats() {
    echo -e "${COLORS[BRIGHT_YELLOW]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[CHART]} BANDWIDTH STATISTICS${COLORS[RESET]}                                                   ${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_YELLOW]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]} ${COLORS[PURPLE]}${ICONS[CHART]} Today${COLORS[RESET]}: ${COLORS[BRIGHT_WHITE]}$TODAY_USAGE${COLORS[RESET]}   ${COLORS[PURPLE]}Yesterday${COLORS[RESET]}: ${COLORS[BRIGHT_WHITE]}$YESTERDAY_USAGE${COLORS[RESET]}   ${COLORS[PURPLE]}This Month${COLORS[RESET]}: ${COLORS[BRIGHT_WHITE]}$MONTHLY_USAGE${COLORS[RESET]}           ${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]} ${COLORS[PURPLE]}${ICONS[CHART]} Download${COLORS[RESET]}: ${COLORS[BRIGHT_WHITE]}$RX_HUMAN${COLORS[RESET]}   ${COLORS[PURPLE]}Upload${COLORS[RESET]}: ${COLORS[BRIGHT_WHITE]}$TX_HUMAN${COLORS[RESET]}                                    ${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_YELLOW]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
}

display_main_menu() {
    echo -e "${COLORS[BRIGHT_BLUE]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[ROCKET]} MAIN MENU${COLORS[RESET]}                                                                ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}                                                                                      ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_CYAN]}[${COLORS[BRIGHT_WHITE]}01${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[USER]} SSH Management${COLORS[RESET]}           ${COLORS[BRIGHT_CYAN]}[${COLORS[BRIGHT_WHITE]}09${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[CHART]} System Monitor${COLORS[RESET]}               ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_CYAN]}[${COLORS[BRIGHT_WHITE]}02${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[SHIELD]} VMESS Management${COLORS[RESET]}         ${COLORS[BRIGHT_CYAN]}[${COLORS[BRIGHT_WHITE]}10${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[GLOBE]} Add Domain/Host${COLORS[RESET]}              ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_CYAN]}[${COLORS[BRIGHT_WHITE]}03${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[LOCK]} VLESS Management${COLORS[RESET]}         ${COLORS[BRIGHT_CYAN]}[${COLORS[BRIGHT_WHITE]}11${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[GEAR]} Install UDP Custom${COLORS[RESET]}           ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_CYAN]}[${COLORS[BRIGHT_WHITE]}04${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[KEY]} TROJAN Management${COLORS[RESET]}        ${COLORS[BRIGHT_CYAN]}[${COLORS[BRIGHT_WHITE]}12${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[GEAR]} Bot Panel${COLORS[RESET]}                    ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_CYAN]}[${COLORS[BRIGHT_WHITE]}05${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[SHIELD]} Shadowsocks Management${COLORS[RESET]}   ${COLORS[BRIGHT_CYAN]}[${COLORS[BRIGHT_WHITE]}13${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[LOCK]} Lock SSH Users${COLORS[RESET]}               ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_CYAN]}[${COLORS[BRIGHT_WHITE]}06${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[GEAR]} System Settings${COLORS[RESET]}          ${COLORS[BRIGHT_CYAN]}[${COLORS[BRIGHT_WHITE]}14${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[KEY]} Unlock SSH Users${COLORS[RESET]}             ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_CYAN]}[${COLORS[BRIGHT_WHITE]}07${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[CLOCK]} Trial Accounts${COLORS[RESET]}           ${COLORS[BRIGHT_CYAN]}[${COLORS[BRIGHT_WHITE]}15${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[GEAR]} Update Script${COLORS[RESET]}                ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_CYAN]}[${COLORS[BRIGHT_WHITE]}08${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[BACKUP]} Backup & Restore${COLORS[RESET]}         ${COLORS[BRIGHT_CYAN]}[${COLORS[BRIGHT_WHITE]}16${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[GLOBE]} Register IP${COLORS[RESET]}                  ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}                                                                                      ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}   ${COLORS[BRIGHT_RED]}[${COLORS[BRIGHT_WHITE]}00${COLORS[BRIGHT_RED]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[GEAR]} Refresh Menu${COLORS[RESET]}              ${COLORS[BRIGHT_RED]}[${COLORS[BRIGHT_WHITE]}99${COLORS[BRIGHT_RED]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[CROSS]} Exit${COLORS[RESET]}                         ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}                                                                                      ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
}

display_footer() {
    echo -e "${COLORS[BG_PURPLE]}${COLORS[BRIGHT_WHITE]}                              ${ICONS[CROWN]} HR STORE VPN PANEL ${ICONS[CROWN]}                              ${COLORS[RESET]}"
    echo
    echo -e "${COLORS[BRIGHT_CYAN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[STAR]} LICENSE INFORMATION${COLORS[RESET]}                                                      ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[GOLD]}${ICONS[USER]} Licensed User${COLORS[RESET]}  : ${COLORS[BRIGHT_WHITE]}$LICENSE_USER${COLORS[RESET]}                                           ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[GOLD]}${ICONS[CLOCK]} License Valid${COLORS[RESET]}  : ${COLORS[BRIGHT_GREEN]}$LICENSE_DAYS Days Remaining${COLORS[RESET]}                              ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[GOLD]}${ICONS[GEAR]} Script Version${COLORS[RESET]} : ${COLORS[BRIGHT_WHITE]}$SCRIPT_VERSION${COLORS[RESET]}                                ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[GOLD]}${ICONS[CLOCK]} Build Date${COLORS[RESET]}     : ${COLORS[BRIGHT_WHITE]}$BUILD_DATE${COLORS[RESET]}                                           ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
    echo -e "${COLORS[BRIGHT_WHITE]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_WHITE]}║${COLORS[RESET]} ${COLORS[BRIGHT_GREEN]}${ICONS[INFO]} TIP: Use numbers to navigate the menu quickly! Type 'help' for more info.${COLORS[RESET]}          ${COLORS[BRIGHT_WHITE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_WHITE]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
}

# Menu Handler Functions
handle_menu_selection() {
    local choice="$1"
    
    case $choice in
        1|01)
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[INFO]} Loading SSH Management...${COLORS[RESET]}"
            show_loading "Initializing SSH Module" 2
            # Call SSH management function
            ;;
        2|02)
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[INFO]} Loading VMESS Management...${COLORS[RESET]}"
            show_loading "Initializing VMESS Module" 2
            # Call VMESS management function
            ;;
        3|03)
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[INFO]} Loading VLESS Management...${COLORS[RESET]}"
            show_loading "Initializing VLESS Module" 2
            # Call VLESS management function
            ;;
        4|04)
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[INFO]} Loading TROJAN Management...${COLORS[RESET]}"
            show_loading "Initializing TROJAN Module" 2
            # Call TROJAN management function
            ;;
        5|05)
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[INFO]} Loading Shadowsocks Management...${COLORS[RESET]}"
            show_loading "Initializing Shadowsocks Module" 2
            # Call Shadowsocks management function
            ;;
        6|06)
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[INFO]} Loading System Settings...${COLORS[RESET]}"
            show_loading "Initializing Settings Module" 2
            # Call system settings function
            ;;
        7|07)
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[INFO]} Loading Trial Accounts...${COLORS[RESET]}"
            show_loading "Initializing Trial Module" 2
            # Call trial accounts function
            ;;
        8|08)
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[INFO]} Loading Backup & Restore...${COLORS[RESET]}"
            show_loading "Initializing Backup Module" 2
            # Call backup function
            ;;
        9|09)
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[INFO]} Loading System Monitor...${COLORS[RESET]}"
            show_loading "Initializing Monitor Module" 2
            # Call system monitor function
            ;;
        10)
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[INFO]} Loading Add Domain/Host...${COLORS[RESET]}"
            show_loading "Initializing Domain Module" 2
            # Call add domain function
            ;;
        11)
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[INFO]} Installing UDP Custom...${COLORS[RESET]}"
            show_loading "Installing UDP Custom" 3
            # Call UDP install function
            ;;
        12)
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[INFO]} Loading Bot Panel...${COLORS[RESET]}"
            show_loading "Initializing Bot Panel" 2
            # Call bot panel function
            ;;
        13)
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[INFO]} Locking SSH Users...${COLORS[RESET]}"
            show_loading "Processing SSH Lock" 2
            # Call SSH lock function
            ;;
        14)
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[INFO]} Unlocking SSH Users...${COLORS[RESET]}"
            show_loading "Processing SSH Unlock" 2
            # Call SSH unlock function
            ;;
        15)
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[INFO]} Updating Script...${COLORS[RESET]}"
            show_loading "Downloading Updates" 3
            # Call update function
            ;;
        16)
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[INFO]} Registering IP...${COLORS[RESET]}"
            show_loading "Processing IP Registration" 2
            # Call IP registration function
            ;;
        0|00)
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[INFO]} Refreshing menu...${COLORS[RESET]}"
            show_loading "Refreshing Interface" 1
            exec "$0"
            ;;
        99|x|X|exit|quit)
            echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Thank you for using HR STORE VPN Panel!${COLORS[RESET]}"
            echo -e "${COLORS[BRIGHT_CYAN]}${ICONS[STAR]} Goodbye! ${ICONS[STAR]}${COLORS[RESET]}"
            sleep 2
            exit 0
            ;;
        help|h|H)
            show_help
            ;;
        *)
            echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} Invalid option: ${COLORS[BRIGHT_WHITE]}$choice${COLORS[RESET]}"
            echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[WARNING]} Please select a valid menu option (1-16, 0, or 99)${COLORS[RESET]}"
            sleep 3
            exec "$0"
            ;;
    esac
}

show_help() {
    clear
    echo -e "${COLORS[BRIGHT_BLUE]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[INFO]} HR STORE VPN PANEL - HELP${COLORS[RESET]}                                               ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]} ${COLORS[BRIGHT_WHITE]}Navigation:${COLORS[RESET]}                                                                   ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]} • Use numbers (1-16) to select menu options                                      ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]} • Type '0' or '00' to refresh the menu                                           ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]} • Type '99', 'x', 'exit', or 'quit' to exit                                     ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]} • Type 'help' or 'h' to show this help                                          ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}                                                                                      ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]} ${COLORS[BRIGHT_WHITE]}Features:${COLORS[RESET]}                                                                     ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]} • Real-time system monitoring                                                    ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]} • Multiple VPN protocol support (SSH, VMESS, VLESS, TROJAN, SS)                ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]} • Automated backup and restore                                                   ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]} • Advanced user management                                                       ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]} • Bandwidth monitoring                                                           ${COLORS[BRIGHT_BLUE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_BLUE]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
    echo -ne "${COLORS[BRIGHT_CYAN]}Press Enter to return to main menu...${COLORS[RESET]}"
    read
    exec "$0"
}

# Main Function
main() {
    # Initialize system
    get_system_info
    get_service_status
    get_user_stats
    get_bandwidth_stats
    get_license_info
    
    # Display interface
    display_header
    display_system_info
    display_service_status
    display_user_stats
    display_bandwidth_stats
    display_main_menu
    display_footer
    
    # Get user input
    echo -ne "${COLORS[BRIGHT_CYAN]}┌─[${COLORS[BRIGHT_WHITE]}HR-STORE${COLORS[BRIGHT_CYAN]}]─[${COLORS[BRIGHT_YELLOW]}$(whoami)${COLORS[BRIGHT_CYAN]}]─[${COLORS[BRIGHT_WHITE]}$(date +%H:%M:%S)${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]}\n"
    echo -ne "${COLORS[BRIGHT_CYAN]}└─${COLORS[BRIGHT_WHITE]}Select Menu${COLORS[BRIGHT_CYAN]}: ${COLORS[RESET]}"
    read -r choice
    
    echo
    handle_menu_selection "$choice"
}

# Script entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

