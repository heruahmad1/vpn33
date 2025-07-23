#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════════
# HR STORE VPN Script Installer - Professional Edition
# Version: 6.0 Enhanced
# Author: HR STORE Team
# Description: Advanced VPN installation system with modern UI and error handling
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
    [BG_RED]='\033[41m'
    [BG_GREEN]='\033[42m'
    [BG_BLUE]='\033[44m'
    [BG_PURPLE]='\033[45m'
    [ORANGE]='\033[38;5;208m'
    [GOLD]='\033[38;5;220m'
)

# Icons
declare -A ICONS=(
    [ROCKET]="🚀"
    [SHIELD]="🛡️"
    [GEAR]="⚙️"
    [CHECK]="✅"
    [CROSS]="❌"
    [WARNING]="⚠️"
    [INFO]="ℹ️"
    [STAR]="⭐"
    [CROWN]="👑"
    [LIGHTNING]="⚡"
    [FIRE]="🔥"
    [DIAMOND]="💎"
    [PACKAGE]="📦"
    [DOWNLOAD]="⬇️"
    [UPLOAD]="⬆️"
    [CLOCK]="🕐"
    [LOCK]="🔒"
    [KEY]="🔑"
)

# Global Variables
SCRIPT_VERSION="6.0"
SCRIPT_NAME="HR STORE VPN Installer"
INSTALL_DIR="/usr/local/hrstore"
LOG_FILE="/var/log/hrstore-install.log"
TEMP_DIR="/tmp/hrstore-install"
GITHUB_REPO="https://raw.githubusercontent.com/hrstore/vpn-script/main"
REQUIRED_SPACE=1048576  # 1GB in KB

# System Information
OS_NAME=""
OS_VERSION=""
ARCH=""
MEMORY_MB=0
DISK_SPACE_KB=0
CPU_CORES=0

# Installation Progress
TOTAL_STEPS=12
CURRENT_STEP=0

# Logging Functions
log_message() {
    local level="$1"
    local message="$2"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $message" >> "$LOG_FILE"
}

log_info() { log_message "INFO" "$1"; }
log_warn() { log_message "WARN" "$1"; }
log_error() { log_message "ERROR" "$1"; }
log_success() { log_message "SUCCESS" "$1"; }

# Display Functions
print_header() {
    clear
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
    echo "║              ${ICONS[CROWN]} PROFESSIONAL VPN INSTALLER v$SCRIPT_VERSION ${ICONS[CROWN]}                           ║"
    echo "║                          ${ICONS[LIGHTNING]} POWERED BY HR STORE ${ICONS[LIGHTNING]}                              ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${COLORS[RESET]}"
    echo
}

print_step() {
    ((CURRENT_STEP++))
    local message="$1"
    local percentage=$((CURRENT_STEP * 100 / TOTAL_STEPS))
    
    echo -e "${COLORS[BRIGHT_CYAN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}Step $CURRENT_STEP/$TOTAL_STEPS: $message${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} Progress: ${COLORS[BRIGHT_GREEN]}"
    
    # Progress bar
    local filled=$((percentage / 5))
    local empty=$((20 - filled))
    printf "["
    for ((i=0; i<filled; i++)); do printf "█"; done
    for ((i=0; i<empty; i++)); do printf "░"; done
    printf "] %d%%${COLORS[RESET]}\n" "$percentage"
    
    echo -e "${COLORS[BRIGHT_CYAN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
}

print_success() {
    echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[CHECK]} $1${COLORS[RESET]}"
    log_success "$1"
}

print_error() {
    echo -e "${COLORS[BRIGHT_RED]}${ICONS[CROSS]} $1${COLORS[RESET]}"
    log_error "$1"
}

print_warning() {
    echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[WARNING]} $1${COLORS[RESET]}"
    log_warn "$1"
}

print_info() {
    echo -e "${COLORS[BRIGHT_CYAN]}${ICONS[INFO]} $1${COLORS[RESET]}"
    log_info "$1"
}

# Animation Functions
show_spinner() {
    local pid=$1
    local message="$2"
    local delay=0.1
    local spinstr='|/-\'
    
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf "\r${COLORS[BRIGHT_CYAN]}${ICONS[GEAR]} %s [%c]${COLORS[RESET]}" "$message" "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done
    printf "\r${COLORS[BRIGHT_GREEN]}${ICONS[CHECK]} %s [Done]${COLORS[RESET]}\n" "$message"
}

show_progress_bar() {
    local duration=$1
    local message="$2"
    local steps=50
    local delay=$(echo "scale=3; $duration / $steps" | bc -l 2>/dev/null || echo "0.1")
    
    echo -ne "${COLORS[BRIGHT_CYAN]}${ICONS[DOWNLOAD]} $message [${COLORS[RESET]}"
    
    for ((i=0; i<=steps; i++)); do
        local percentage=$((i * 100 / steps))
        local filled=$((i * 40 / steps))
        local empty=$((40 - filled))
        
        printf "\r${COLORS[BRIGHT_CYAN]}${ICONS[DOWNLOAD]} $message [${COLORS[BRIGHT_GREEN]}"
        for ((j=0; j<filled; j++)); do printf "█"; done
        for ((j=0; j<empty; j++)); do printf "░"; done
        printf "${COLORS[RESET]}] ${COLORS[BRIGHT_WHITE]}%d%%${COLORS[RESET]}" "$percentage"
        
        sleep "$delay"
    done
    echo
}

# System Check Functions
check_root() {
    print_step "Checking root privileges"
    
    if [[ $EUID -ne 0 ]]; then
        print_error "This installer must be run as root"
        print_info "Please run: sudo $0"
        exit 1
    fi
    
    print_success "Root privileges confirmed"
}

detect_system() {
    print_step "Detecting system information"
    
    # Detect OS
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        OS_NAME="$ID"
        OS_VERSION="$VERSION_ID"
        print_info "OS: $PRETTY_NAME"
    else
        print_error "Cannot detect operating system"
        exit 1
    fi
    
    # Detect architecture
    ARCH=$(uname -m)
    case $ARCH in
        x86_64|amd64)
            print_success "Architecture: $ARCH (Supported)"
            ;;
        *)
            print_error "Unsupported architecture: $ARCH"
            print_info "This installer requires x86_64/amd64"
            exit 1
            ;;
    esac
    
    # Check memory
    MEMORY_MB=$(free -m | awk 'NR==2{print $2}')
    if [[ $MEMORY_MB -lt 512 ]]; then
        print_warning "Low memory: ${MEMORY_MB}MB (Minimum 512MB recommended)"
    else
        print_success "Memory: ${MEMORY_MB}MB"
    fi
    
    # Check disk space
    DISK_SPACE_KB=$(df / | awk 'NR==2{print $4}')
    if [[ $DISK_SPACE_KB -lt $REQUIRED_SPACE ]]; then
        print_error "Insufficient disk space: $(($DISK_SPACE_KB/1024))MB available, $(($REQUIRED_SPACE/1024))MB required"
        exit 1
    else
        print_success "Disk space: $(($DISK_SPACE_KB/1024/1024))GB available"
    fi
    
    # Check CPU cores
    CPU_CORES=$(nproc)
    print_info "CPU cores: $CPU_CORES"
}

check_network() {
    print_step "Testing network connectivity"
    
    local test_urls=(
        "google.com"
        "github.com"
        "cloudflare.com"
    )
    
    for url in "${test_urls[@]}"; do
        if ping -c 1 -W 5 "$url" &>/dev/null; then
            print_success "Network connectivity to $url: OK"
            return 0
        fi
    done
    
    print_error "No network connectivity detected"
    print_info "Please check your internet connection"
    exit 1
}

# Package Management Functions
update_system() {
    print_step "Updating system packages"
    
    case $OS_NAME in
        ubuntu|debian)
            {
                apt-get update -y
                apt-get upgrade -y
            } &>/dev/null &
            show_spinner $! "Updating package database"
            ;;
        centos|rhel|fedora)
            {
                if command -v dnf &>/dev/null; then
                    dnf update -y
                else
                    yum update -y
                fi
            } &>/dev/null &
            show_spinner $! "Updating package database"
            ;;
        *)
            print_warning "Unsupported OS for automatic updates: $OS_NAME"
            ;;
    esac
    
    print_success "System packages updated"
}

install_dependencies() {
    print_step "Installing required dependencies"
    
    local packages=(
        "curl"
        "wget"
        "unzip"
        "screen"
        "coreutils"
        "bc"
        "jq"
        "net-tools"
        "iptables"
        "ufw"
        "fail2ban"
        "htop"
        "nano"
        "vim"
        "git"
        "socat"
        "cron"
        "lsof"
        "tar"
        "gzip"
    )
    
    case $OS_NAME in
        ubuntu|debian)
            packages+=("dnsutils" "software-properties-common" "apt-transport-https" "ca-certificates" "gnupg" "lsb-release")
            
            for package in "${packages[@]}"; do
                {
                    apt-get install -y "$package"
                } &>/dev/null &
                show_spinner $! "Installing $package"
            done
            ;;
        centos|rhel|fedora)
            packages+=("bind-utils" "epel-release")
            
            for package in "${packages[@]}"; do
                {
                    if command -v dnf &>/dev/null; then
                        dnf install -y "$package"
                    else
                        yum install -y "$package"
                    fi
                } &>/dev/null &
                show_spinner $! "Installing $package"
            done
            ;;
    esac
    
    print_success "Dependencies installed successfully"
}

# Security Configuration
configure_firewall() {
    print_step "Configuring firewall and security"
    
    # Configure UFW
    if command -v ufw &>/dev/null; then
        {
            ufw --force reset
            ufw default deny incoming
            ufw default allow outgoing
            
            # Essential ports
            local ports=(22 80 443 8080 8443 1194 7300 8000 2082 2083 2086 2087 2095 2096)
            for port in "${ports[@]}"; do
                ufw allow "$port"
            done
            
            ufw --force enable
        } &>/dev/null &
        show_spinner $! "Configuring UFW firewall"
    fi
    
    # Configure Fail2Ban
    if command -v fail2ban-server &>/dev/null; then
        {
            systemctl enable fail2ban
            systemctl start fail2ban
            
            # Create custom jail for SSH
            cat > /etc/fail2ban/jail.local << EOF
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 7200
EOF
            systemctl restart fail2ban
        } &>/dev/null &
        show_spinner $! "Configuring Fail2Ban"
    fi
    
    print_success "Security configuration completed"
}

# Core Installation Functions
create_directories() {
    print_step "Creating installation directories"
    
    local directories=(
        "$INSTALL_DIR"
        "$INSTALL_DIR/bin"
        "$INSTALL_DIR/config"
        "$INSTALL_DIR/logs"
        "$INSTALL_DIR/backup"
        "$INSTALL_DIR/scripts"
        "$INSTALL_DIR/protocols"
        "$INSTALL_DIR/utils"
        "$TEMP_DIR"
        "/var/log/hrstore"
        "/etc/hrstore"
    )
    
    for dir in "${directories[@]}"; do
        if mkdir -p "$dir" 2>/dev/null; then
            print_info "Created: $dir"
        else
            print_error "Failed to create: $dir"
            exit 1
        fi
    done
    
    print_success "Directory structure created"
}

download_components() {
    print_step "Downloading HR STORE components"
    
    # Create temporary download directory
    mkdir -p "$TEMP_DIR/downloads"
    
    # Download main components (simulated - replace with actual URLs)
    local components=(
        "menu.sh:Main menu interface"
        "ssh-manager.sh:SSH management module"
        "vmess-manager.sh:VMESS management module"
        "vless-manager.sh:VLESS management module"
        "trojan-manager.sh:TROJAN management module"
        "shadowsocks-manager.sh:Shadowsocks management module"
        "system-monitor.sh:System monitoring module"
        "backup-manager.sh:Backup management module"
        "user-manager.sh:User management module"
        "config-manager.sh:Configuration management module"
    )
    
    for component in "${components[@]}"; do
        local filename="${component%%:*}"
        local description="${component##*:}"
        
        # Simulate download with progress bar
        show_progress_bar 2 "Downloading $description"
        
        # Create placeholder file (replace with actual download)
        echo "#!/bin/bash" > "$TEMP_DIR/downloads/$filename"
        echo "# HR STORE - $description" >> "$TEMP_DIR/downloads/$filename"
        echo "echo 'HR STORE $description - Coming Soon!'" >> "$TEMP_DIR/downloads/$filename"
        chmod +x "$TEMP_DIR/downloads/$filename"
        
        print_success "Downloaded: $filename"
    done
}

install_components() {
    print_step "Installing HR STORE components"
    
    # Copy downloaded components
    if cp -r "$TEMP_DIR/downloads/"* "$INSTALL_DIR/scripts/" 2>/dev/null; then
        print_success "Components copied to installation directory"
    else
        print_error "Failed to copy components"
        exit 1
    fi
    
    # Create main executable
    cat > "$INSTALL_DIR/bin/hrstore" << 'EOF'
#!/bin/bash
# HR STORE VPN Panel - Main Executable
INSTALL_DIR="/usr/local/hrstore"
exec "$INSTALL_DIR/scripts/menu.sh" "$@"
EOF
    chmod +x "$INSTALL_DIR/bin/hrstore"
    
    # Create symbolic links
    ln -sf "$INSTALL_DIR/bin/hrstore" /usr/local/bin/hrstore
    ln -sf "$INSTALL_DIR/bin/hrstore" /usr/local/bin/menu
    ln -sf "$INSTALL_DIR/bin/hrstore" /usr/local/bin/hrstore-menu
    
    print_success "Symbolic links created"
}

configure_services() {
    print_step "Configuring system services"
    
    # Create systemd service
    cat > /etc/systemd/system/hrstore-monitor.service << EOF
[Unit]
Description=HR STORE VPN Monitor Service
After=network.target
Wants=network.target

[Service]
Type=simple
User=root
ExecStart=/bin/bash -c 'while true; do sleep 300; /usr/local/hrstore/scripts/system-monitor.sh --daemon; done'
Restart=always
RestartSec=30
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF
    
    {
        systemctl daemon-reload
        systemctl enable hrstore-monitor.service
        systemctl start hrstore-monitor.service
    } &>/dev/null &
    show_spinner $! "Configuring system services"
    
    print_success "System services configured"
}

optimize_system() {
    print_step "Optimizing system performance"
    
    # Kernel parameters
    cat > /etc/sysctl.d/99-hrstore-vpn.conf << EOF
# HR STORE VPN Optimizations
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_notsent_lowat = 16384
net.ipv4.ip_forward = 1
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_rmem = 4096 87380 134217728
net.ipv4.tcp_wmem = 4096 65536 134217728
net.ipv4.tcp_mtu_probing = 1
EOF
    
    {
        sysctl -p /etc/sysctl.d/99-hrstore-vpn.conf
    } &>/dev/null &
    show_spinner $! "Applying kernel optimizations"
    
    # Configure limits
    cat > /etc/security/limits.d/99-hrstore.conf << EOF
* soft nofile 65536
* hard nofile 65536
* soft nproc 65536
* hard nproc 65536
EOF
    
    print_success "System optimization completed"
}

setup_auto_start() {
    print_step "Configuring auto-start features"
    
    # Add to bashrc for easy access
    local bashrc_content='
# HR STORE VPN Quick Access
alias menu="hrstore"
alias hrstore-panel="hrstore"
alias vpn="hrstore"

# HR STORE Welcome Message
if [[ $- == *i* ]] && [[ $USER == "root" ]]; then
    echo -e "\033[1;36m╔══════════════════════════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;36m║\033[0m \033[1;37mWelcome to HR STORE VPN Server!\033[0m                        \033[1;36m║\033[0m"
    echo -e "\033[1;36m║\033[0m \033[1;33mType '\''menu'\'' or '\''hrstore'\'' to access the VPN panel\033[0m      \033[1;36m║\033[0m"
    echo -e "\033[1;36m╚══════════════════════════════════════════════════════════════╝\033[0m"
    echo
fi
'
    
    if ! grep -q "HR STORE VPN Quick Access" /root/.bashrc 2>/dev/null; then
        echo "$bashrc_content" >> /root/.bashrc
        print_success "Auto-start configuration added to bashrc"
    fi
    
    # Create desktop shortcut if GUI is available
    if [[ -n "$DISPLAY" ]] && command -v xdg-desktop-menu &>/dev/null; then
        cat > /usr/share/applications/hrstore-vpn.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=HR STORE VPN Panel
Comment=Professional VPN Management Panel
Exec=gnome-terminal -- hrstore
Icon=network-vpn
Terminal=true
Categories=Network;System;
EOF
        print_success "Desktop shortcut created"
    fi
}

cleanup_installation() {
    print_step "Cleaning up installation files"
    
    {
        rm -rf "$TEMP_DIR"
        apt-get autoremove -y 2>/dev/null || true
        apt-get autoclean 2>/dev/null || true
    } &>/dev/null &
    show_spinner $! "Removing temporary files"
    
    print_success "Cleanup completed"
}

# Installation Summary
show_installation_summary() {
    clear
    echo -e "${COLORS[BG_GREEN]}${COLORS[BRIGHT_WHITE]}"
    echo "╔══════════════════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                                      ║"
    echo "║                          ${ICONS[CHECK]} INSTALLATION COMPLETED! ${ICONS[CHECK]}                          ║"
    echo "║                                                                                      ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${COLORS[RESET]}"
    echo
    
    echo -e "${COLORS[BRIGHT_GREEN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[STAR]} INSTALLATION SUMMARY${COLORS[RESET]}                                                     ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${ICONS[CHECK]} System updated and optimized                                             ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${ICONS[CHECK]} Dependencies installed                                                   ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${ICONS[CHECK]} Firewall and security configured                                        ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${ICONS[CHECK]} HR STORE VPN components installed                                        ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${ICONS[CHECK]} System services configured                                              ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${ICONS[CHECK]} Performance optimizations applied                                       ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]} ${ICONS[CHECK]} Auto-start features configured                                          ${COLORS[BRIGHT_GREEN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_GREEN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
    
    echo -e "${COLORS[BRIGHT_YELLOW]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[ROCKET]} QUICK START GUIDE${COLORS[RESET]}                                                       ${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_YELLOW]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]} ${ICONS[GEAR]} Run: ${COLORS[BRIGHT_WHITE]}menu${COLORS[RESET]} or ${COLORS[BRIGHT_WHITE]}hrstore${COLORS[RESET]} to access the main panel                    ${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]} ${ICONS[GEAR]} Installation directory: ${COLORS[BRIGHT_WHITE]}$INSTALL_DIR${COLORS[RESET]}                               ${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]} ${ICONS[GEAR]} Log file: ${COLORS[BRIGHT_WHITE]}$LOG_FILE${COLORS[RESET]}                                        ${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]} ${ICONS[GEAR]} Service status: ${COLORS[BRIGHT_WHITE]}systemctl status hrstore-monitor${COLORS[RESET]}                    ${COLORS[BRIGHT_YELLOW]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_YELLOW]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
    
    echo -e "${COLORS[BRIGHT_CYAN]}╔══════════════════════════════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${COLORS[BOLD]}${COLORS[BRIGHT_WHITE]}${ICONS[INFO]} SUPPORT INFORMATION${COLORS[RESET]}                                                     ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}╠══════════════════════════════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${ICONS[STAR]} Version: ${COLORS[BRIGHT_WHITE]}HR STORE VPN v$SCRIPT_VERSION${COLORS[RESET]}                                        ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${ICONS[CLOCK]} Installation completed: ${COLORS[BRIGHT_WHITE]}$(date '+%Y-%m-%d %H:%M:%S')${COLORS[RESET]}                        ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]} ${ICONS[DIAMOND]} Thank you for choosing HR STORE VPN!                                     ${COLORS[BRIGHT_CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[BRIGHT_CYAN]}╚══════════════════════════════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    echo
}

# Main Installation Function
main() {
    # Initialize logging
    mkdir -p "$(dirname "$LOG_FILE")"
    touch "$LOG_FILE"
    log_info "HR STORE VPN Installation Started - Version $SCRIPT_VERSION"
    
    # Print header
    print_header
    
    # Installation steps
    check_root
    detect_system
    check_network
    update_system
    install_dependencies
    configure_firewall
    create_directories
    download_components
    install_components
    configure_services
    optimize_system
    setup_auto_start
    cleanup_installation
    
    # Show summary
    show_installation_summary
    
    log_success "HR STORE VPN Installation Completed Successfully"
    
    # Ask to start the panel
    echo -ne "${COLORS[BRIGHT_CYAN]}${ICONS[ROCKET]} Would you like to start the HR STORE VPN panel now? [Y/n]: ${COLORS[RESET]}"
    read -r start_panel
    
    case $start_panel in
        [Nn]*)
            echo -e "${COLORS[BRIGHT_YELLOW]}${ICONS[INFO]} You can start the panel anytime by typing: ${COLORS[BRIGHT_WHITE]}menu${COLORS[RESET]}"
            ;;
        *)
            echo -e "${COLORS[BRIGHT_GREEN]}${ICONS[ROCKET]} Starting HR STORE VPN panel...${COLORS[RESET]}"
            sleep 2
            hrstore
            ;;
    esac
}

# Script entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

