#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════════
# HR STORE System Monitor Utility
# Version: 6.0 Enhanced
# Author: HR STORE Team
# Description: Advanced system monitoring with real-time statistics
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
    [BG_RED]='\033[41m'
    [BG_YELLOW]='\033[43m'
)

# Icons
declare -A ICONS=(
    [CHART]="📊"
    [CPU]="🖥️"
    [MEMORY]="💾"
    [DISK]="💿"
    [NETWORK]="🌐"
    [PROCESS]="⚙️"
    [USER]="👤"
    [CLOCK]="🕐"
    [WARNING]="⚠️"
    [CHECK]="✅"
    [CROSS]="❌"
    [INFO]="ℹ️"
    [FIRE]="🔥"
    [LIGHTNING]="⚡"
    [SHIELD]="🛡️"
    [BACK]="⬅️"
    [REFRESH]="🔄"
)

# System monitoring functions
get_cpu_usage() {
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    echo "${cpu_usage:-0}"
}

get_memory_usage() {
    local mem_info=$(free | awk 'NR==2{printf "%.1f %.1f %.1f", $3*100/$2, $2/1024/1024, $3/1024/1024}')
    echo "$mem_info"
}

get_disk_usage() {
    local disk_info=$(df -h / | awk 'NR==2{printf "%s %s %s %s", $2, $3, $4, $5}')
    echo "$disk_info"
}

get_network_stats() {
    local interface=$(ip route | awk '/default/ {print $5; exit}')
    if [[ -n "$interface" ]]; then
        local rx_bytes=$(cat /sys/class/net/$interface/statistics/rx_bytes 2>/dev/null || echo 0)
        local tx_bytes=$(cat /sys/class/net/$interface/statistics/tx_bytes 2>/dev/null || echo 0)
        local rx_human=$(numfmt --to=iec-i --suffix=B $rx_bytes 2>/dev/null || echo "0B")
        local tx_human=$(numfmt --to=iec-i --suffix=B $tx_bytes 2>/dev/null || echo "0B")
        echo "$interface $rx_human $tx_human"
    else
        echo "N/A 0B 0B"
    fi
}

get_load_average() {
    local load=$(uptime | awk -F'load average:' '{print $2}' | sed 's/^ *//')
    echo "$load"
}

get_top_processes() {
    ps aux --sort=-%cpu | head -6 | tail -5
}

get_system_uptime() {
    uptime -p | sed 's/up //'
}

get_logged_users() {
    who | wc -l
}

# Display functions
print_header() {
    clear
    echo -e "${COLORS[BG_BLUE]}${COLORS[BRIGHT_WHITE]}"
    echo "╔══════════════════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                                      ║"
    echo "║                   ${ICONS[CHART]} HR STORE SYSTEM MONITOR ${ICONS[CHART]}                           ║"
    echo "║                                                                                      ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${COLORS[RESET]}"
    echo
}

print_system_overview() {
    local cpu_usage=$(get_cpu_usage)
    local mem_info=($(get_memory_usage))
    local mem_percent=${mem_info[0]}
    local mem_total=${mem_info[1]}
    local mem_used=${mem_info[2]}
    local disk_info=($(get_disk_usage))
    local disk_total=${disk_info[0]}
    local disk_used=${disk_info[1]}
    local disk_free=${disk_info[2]}
    local disk_percent=${disk_info[3]}
    local load_avg=$(get_load_average)
    local uptime=$(get_system_uptime)
    local logged_users=$(get_logged_users)
    
    echo -e "${COLORS[BRIGHT_CYAN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[CHART]} SYSTEM OVERVIEW${COLORS[RESET]}                                                          ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    
    # CPU Usage with color coding
    local cpu_color="${COLORS[BRIGHT_GREEN]}"
    if (( $(echo "$cpu_usage > 70" | bc -l 2>/dev/null || echo 0) )); then
        cpu_color="${COLORS[BRIGHT_RED]}"
    elif (( $(echo "$cpu_usage > 50" | bc -l 2>/dev/null || echo 0) )); then
        cpu_color="${COLORS[BRIGHT_YELLOW]}"
    fi
    
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}${ICONS[CPU]} CPU Usage${COLORS[RESET]}    : $cpu_color$cpu_usage%${COLORS[RESET]}"
    
    # Memory Usage with color coding
    local mem_color="${COLORS[BRIGHT_GREEN]}"
    if (( $(echo "$mem_percent > 80" | bc -l 2>/dev/null || echo 0) )); then
        mem_color="${COLORS[BRIGHT_RED]}"
    elif (( $(echo "$mem_percent > 60" | bc -l 2>/dev/null || echo 0) )); then
        mem_color="${COLORS[BRIGHT_YELLOW]}"
    fi
    
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}${ICONS[MEMORY]} Memory Usage${COLORS[RESET]}  : $mem_color$mem_percent%${COLORS[RESET]} (${mem_used}GB / ${mem_total}GB)"
    
    # Disk Usage with color coding
    local disk_num=$(echo "$disk_percent" | tr -d '%')
    local disk_color="${COLORS[BRIGHT_GREEN]}"
    if [[ $disk_num -gt 80 ]]; then
        disk_color="${COLORS[BRIGHT_RED]}"
    elif [[ $disk_num -gt 60 ]]; then
        disk_color="${COLORS[BRIGHT_YELLOW]}"
    fi
    
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}${ICONS[DISK]} Disk Usage${COLORS[RESET]}    : $disk_color$disk_percent${COLORS[RESET]} ($disk_used / $disk_total)"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}${ICONS[LIGHTNING]} Load Average${COLORS[RESET]}  : ${COLORS[BRIGHT_WHITE]}$load_avg${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}${ICONS[CLOCK]} Uptime${COLORS[RESET]}        : ${COLORS[BRIGHT_WHITE]}$uptime${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[YELLOW]}${ICONS[USER]} Logged Users${COLORS[RESET]}  : ${COLORS[BRIGHT_WHITE]}$logged_users${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
}

print_network_stats() {
    local net_info=($(get_network_stats))
    local interface=${net_info[0]}
    local rx_bytes=${net_info[1]}
    local tx_bytes=${net_info[2]}
    
    echo -e "${COLORS[BRIGHT_GREEN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[NETWORK]} NETWORK STATISTICS${COLORS[RESET]}                                                   ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[YELLOW]}Interface${COLORS[RESET]}      : ${COLORS[BRIGHT_WHITE]}$interface${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[YELLOW]}Downloaded${COLORS[RESET]}    : ${COLORS[BRIGHT_WHITE]}$rx_bytes${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[YELLOW]}Uploaded${COLORS[RESET]}      : ${COLORS[BRIGHT_WHITE]}$tx_bytes${COLORS[RESET]}"
    
    # Get active connections
    local tcp_connections=$(ss -t | grep ESTAB | wc -l)
    local udp_connections=$(ss -u | wc -l)
    
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[YELLOW]}TCP Connections${COLORS[RESET]} : ${COLORS[BRIGHT_WHITE]}$tcp_connections${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[YELLOW]}UDP Connections${COLORS[RESET]} : ${COLORS[BRIGHT_WHITE]}$udp_connections${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
}

print_top_processes() {
    echo -e "${COLORS[BRIGHT_YELLOW]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[PROCESS]} TOP PROCESSES BY CPU USAGE${COLORS[RESET]}                                            ${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_YELLOW]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]} ${COLORS[BOLD]}PID${COLORS[RESET]}      ${COLORS[BOLD]}USER${COLORS[RESET]}     ${COLORS[BOLD]}CPU%${COLORS[RESET]}   ${COLORS[BOLD]}MEM%${COLORS[RESET]}   ${COLORS[BOLD]}COMMAND${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_YELLOW]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    
    get_top_processes | while read -r line; do
        local pid=$(echo "$line" | awk '{print $2}')
        local user=$(echo "$line" | awk '{print $1}')
        local cpu=$(echo "$line" | awk '{print $3}')
        local mem=$(echo "$line" | awk '{print $4}')
        local command=$(echo "$line" | awk '{for(i=11;i<=NF;i++) printf "%s ", $i; print ""}' | cut -c1-40)
        
        printf "${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]} %-8s %-8s %-6s %-6s %-40s ${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]}\n" \
            "$pid" "$user" "$cpu" "$mem" "$command"
    done
    
    echo -e "${COLORS[BRIGHT_YELLOW]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
}

print_service_status() {
    echo -e "${COLORS[BRIGHT_PURPLE]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[SHIELD]} VPN SERVICES STATUS${COLORS[RESET]}                                                   ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_PURPLE]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    
    local services=("ssh" "nginx" "xray" "stunnel4" "dropbear" "openvpn" "squid")
    
    for service in "${services[@]}"; do
        local status_icon="${COLORS[BRIGHT_RED]}${ICONS[CROSS]}${COLORS[RESET]}"
        local status_text="${COLORS[BRIGHT_RED]}Stopped${COLORS[RESET]}"
        
        if systemctl is-active --quiet "$service" 2>/dev/null; then
            status_icon="${COLORS[BRIGHT_GREEN]}${ICONS[CHECK]}${COLORS[RESET]}"
            status_text="${COLORS[BRIGHT_GREEN]}Running${COLORS[RESET]}"
        elif systemctl is-enabled --quiet "$service" 2>/dev/null; then
            status_icon="${COLORS[BRIGHT_YELLOW]}${ICONS[WARNING]}${COLORS[RESET]}"
            status_text="${COLORS[BRIGHT_YELLOW]}Enabled${COLORS[RESET]}"
        fi
        
        printf "${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]} %-12s : %s %-20s ${COLORS[BRIGHT_PURPLE]}║${COLORS[RESET]}\n" \
            "$service" "$status_icon" "$status_text"
    done
    
    echo -e "${COLORS[BRIGHT_PURPLE]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
}

print_menu() {
    echo -e "${COLORS[BRIGHT_CYAN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[CHART]} MONITOR OPTIONS${COLORS[RESET]}                                                         ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}                                                                                      ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}   ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}1${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[REFRESH]} Refresh Display${COLORS[RESET]}              ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}4${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[PROCESS]} Process Manager${COLORS[RESET]}              ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}   ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}2${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[CHART]} Real-time Monitor${COLORS[RESET]}           ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}5${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[NETWORK]} Network Monitor${COLORS[RESET]}              ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}   ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}3${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[SHIELD]} Service Manager${COLORS[RESET]}             ${COLORS[BRIGHT_GREEN]}[${COLORS[BRIGHT_WHITE]}0${COLORS[BRIGHT_GREEN]}]${COLORS[RESET]} ${COLORS[WHITE]}${ICONS[BACK]} Back to Main Menu${COLORS[RESET]}            ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}                                                                                      ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
}

# Real-time monitoring
real_time_monitor() {
    while true; do
        print_header
        print_system_overview
        print_network_stats
        print_service_status
        
        echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Real-time monitoring... Press Ctrl+C to stop${COLORS[RESET]}"
        echo -e "${COLORS[BRIGHT_CYAN]}${ICONS[CLOCK]} Last updated: $(date '+%Y-%m-%d %H:%M:%S')${COLORS[RESET]}"
        
        sleep 5
    done
}

# Process manager
process_manager() {
    clear
    print_header
    
    echo -e "${COLORS[BRIGHT_GREEN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[PROCESS]} PROCESS MANAGER${COLORS[RESET]}                                                       ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
    
    print_top_processes
    
    echo -e "${COLORS[BRIGHT_CYAN]}Options:${COLORS[RESET]}"
    echo -e "  ${COLORS[BRIGHT_WHITE]}[1]${COLORS[RESET]} Kill process by PID"
    echo -e "  ${COLORS[BRIGHT_WHITE]}[2]${COLORS[RESET]} Show all processes"
    echo -e "  ${COLORS[BRIGHT_WHITE]}[0]${COLORS[RESET]} Back to monitor menu"
    echo
    
    echo -ne "${COLORS[BRIGHT_CYAN]}Select option: ${COLORS[RESET]}"
    read -r choice
    
    case $choice in
        1)
            echo -ne "${COLORS[BRIGHT_CYAN]}Enter PID to kill: ${COLORS[RESET]}"
            read -r pid
            if [[ "$pid" =~ ^[0-9]+$ ]]; then
                if kill -9 "$pid" 2>/dev/null; then
                    echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[CHECK]} Process $pid killed successfully${COLORS[RESET]}"
                else
                    echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} Failed to kill process $pid${COLORS[RESET]}"
                fi
            else
                echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} Invalid PID${COLORS[RESET]}"
            fi
            sleep 2
            ;;
        2)
            echo -e "${COLORS[BRIGHT_CYAN]}${ICONS[INFO]} All processes:${COLORS[RESET]}"
            ps aux | head -20
            echo -ne "${COLORS[BRIGHT_CYAN]}Press Enter to continue...${COLORS[RESET]}"
            read
            ;;
    esac
}

# Network monitor
network_monitor() {
    clear
    print_header
    
    echo -e "${COLORS[BRIGHT_GREEN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[NETWORK]} NETWORK MONITOR${COLORS[RESET]}                                                       ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
    
    print_network_stats
    
    echo -e "${COLORS[BRIGHT_CYAN]}${ICONS[INFO]} Active network connections:${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BOLD]}Protocol${COLORS[RESET]}  ${COLORS[BOLD]}Local Address${COLORS[RESET]}        ${COLORS[BOLD]}Foreign Address${COLORS[RESET]}      ${COLORS[BOLD]}State${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    
    ss -tuln | grep LISTEN | head -10 | while read -r line; do
        local proto=$(echo "$line" | awk '{print $1}')
        local local_addr=$(echo "$line" | awk '{print $5}')
        local state=$(echo "$line" | awk '{print $2}')
        
        printf "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} %-8s %-20s %-20s %-10s ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}\n" \
            "$proto" "$local_addr" "-" "$state"
    done
    
    echo -e "${COLORS[BRIGHT_CYAN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    
    echo
    echo -ne "${COLORS[BRIGHT_CYAN]}Press Enter to continue...${COLORS[RESET]}"
    read
}

# Main monitor function
main_monitor() {
    while true; do
        print_header
        print_system_overview
        print_network_stats
        print_top_processes
        print_service_status
        print_menu
        
        echo -ne "${COLORS[BRIGHT_CYAN]}┌─[${COLORS[BRIGHT_WHITE]}HR-STORE-MONITOR${COLORS[BRIGHT_CYAN]}]─[${COLORS[BRIGHT_YELLOW]}$(whoami)${COLORS[BRIGHT_CYAN]}]─[${COLORS[BRIGHT_WHITE]}$(date +%H:%M:%S)${COLORS[BRIGHT_CYAN]}]${COLORS[RESET]}\n"
        echo -ne "${COLORS[BRIGHT_CYAN]}└─${COLORS[BRIGHT_WHITE]}Select Option${COLORS[BRIGHT_CYAN]}: ${COLORS[RESET]}"
        read -r choice
        
        case $choice in
            1) continue ;;
            2) real_time_monitor ;;
            3) echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} Service manager coming soon!${COLORS[RESET]}"; sleep 2 ;;
            4) process_manager ;;
            5) network_monitor ;;
            0) return 0 ;;
            *) 
                echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} Invalid option: $choice${COLORS[RESET]}"
                sleep 2
                ;;
        esac
    done
}

# Script entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main_monitor
fi

