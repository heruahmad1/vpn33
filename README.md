# HR STORE VPN Management Script v6.0 Enhanced

🚀 **Professional VPN Management Panel with Modern UI**

## 📋 Overview

HR STORE VPN Script adalah sistem manajemen VPN yang canggih dan modern dengan antarmuka pengguna yang menarik. Script ini dirancang khusus untuk HR STORE dengan fitur-fitur terdepan dan tampilan yang profesional.

## ✨ Features

### 🎨 Modern User Interface
- **Colorful Terminal UI** dengan emoji dan ikon
- **Progress bars** dan animasi loading
- **Responsive design** yang mudah digunakan
- **Error handling** yang komprehensif

### 🛡️ VPN Protocol Support
- **SSH** - Secure Shell tunneling
- **VMESS** - V2Ray protocol dengan WebSocket
- **VLESS** - Lightweight V2Ray protocol
- **TROJAN** - Advanced proxy protocol
- **Shadowsocks** - High-performance proxy

### 📊 System Monitoring
- **Real-time system statistics**
- **Network monitoring**
- **Process management**
- **Service status tracking**
- **Resource usage monitoring**

### 💾 Backup & Restore
- **Full system backup** dengan enkripsi
- **Automated backup scheduling**
- **Cloud backup integration**
- **Incremental backups**
- **Easy restore functionality**

### 🔧 Advanced Features
- **User management** dengan expiry dates
- **Traffic monitoring**
- **QR code generation**
- **Configuration export/import**
- **Automated installation**
- **Security hardening**

## 🚀 Quick Installation

### Method 1: One-Line Installer
```bash
wget -O installer.sh https://raw.githubusercontent.com/hrstore/vpn-script/main/install/installer.sh && chmod +x installer.sh && ./installer.sh
```

### Method 2: Manual Installation
```bash
# Download the script package
git clone https://github.com/heruahmad1/vpn33.git
cd vpn-script

# Run the installer
chmod +x install/installer.sh
./install/installer.sh
```

## 📁 Directory Structure

```
hrstore-vpn-script/
├── menu.sh                 # Main menu interface
├── install/
│   └── installer.sh        # Professional installer
├── protocols/
│   ├── ssh-manager.sh      # SSH management
│   ├── vmess-manager.sh    # VMESS management
│   ├── vless-manager.sh    # VLESS management
│   ├── trojan-manager.sh   # TROJAN management
│   └── shadowsocks-manager.sh
├── utils/
│   ├── system-monitor.sh   # System monitoring
│   ├── user-manager.sh     # User management
│   └── config-manager.sh   # Configuration management
├── backup/
│   └── backup-manager.sh   # Backup & restore
└── README.md
```

## 🎯 Usage

### Starting the Panel
```bash
# After installation, use any of these commands:
menu
hrstore
hrstore-menu
```

### Main Menu Options
1. **SSH Management** - Create, manage SSH users
2. **VMESS Management** - V2Ray VMESS protocol
3. **VLESS Management** - V2Ray VLESS protocol  
4. **TROJAN Management** - TROJAN proxy protocol
5. **Shadowsocks Management** - SS proxy protocol
6. **System Settings** - Configure system parameters
7. **Trial Accounts** - Temporary account management
8. **Backup & Restore** - Data backup solutions
9. **System Monitor** - Real-time monitoring
10. **Add Domain/Host** - Domain management
11. **Install UDP Custom** - UDP optimization
12. **Bot Panel** - Telegram bot integration
13. **Lock/Unlock Users** - User access control
14. **Update Script** - Auto-update functionality
15. **Register IP** - IP whitelist management

## 🔧 Configuration

### System Requirements
- **OS**: Ubuntu 18.04+ / Debian 9+ / CentOS 7+
- **RAM**: Minimum 512MB (1GB+ recommended)
- **Storage**: 1GB+ free space
- **Network**: Internet connection required

### Supported Architectures
- x86_64 (amd64)
- ARM64 (planned)

## 🛡️ Security Features

### Firewall Configuration
- **UFW** automatic configuration
- **Fail2Ban** intrusion prevention
- **Port management** with security rules
- **DDoS protection** basic implementation

### Encryption Support
- **AES-256** backup encryption
- **TLS/SSL** for web protocols
- **Password hashing** for user accounts
- **Certificate management**

## 📊 Monitoring & Analytics

### Real-time Metrics
- CPU usage with color coding
- Memory utilization tracking
- Disk space monitoring
- Network traffic statistics
- Active connection counts

### Service Status
- VPN service health checks
- Automatic service recovery
- Performance optimization
- Resource usage alerts

## 💾 Backup System

### Backup Features
- **Full system backup** including:
  - Configuration files
  - User databases
  - System settings
  - VPN configurations
- **Encryption support** with AES-256
- **Compression** for space efficiency
- **Metadata tracking** for easy management

### Restore Options
- **Selective restore** of components
- **Version management**
- **Rollback functionality**
- **Migration support**

## 🔄 Update System

### Auto-Update Features
- **Version checking** against repository
- **Incremental updates** for efficiency
- **Rollback capability** if issues occur
- **Backup before update** for safety

## 🤖 Bot Integration

### Telegram Bot Features (Coming Soon)
- User management via Telegram
- Real-time notifications
- Remote monitoring
- Command execution

## 📱 Mobile Support

### QR Code Generation
- **Automatic QR codes** for mobile clients
- **Multiple format support**
- **Easy sharing** functionality

## 🌐 Multi-Protocol Support

### Protocol Details

#### SSH Tunneling
- **Port**: 22 (customizable)
- **Encryption**: SSH-2 protocol
- **Features**: User management, key authentication

#### VMESS (V2Ray)
- **Port**: 443 (TLS), 80 (non-TLS)
- **Transport**: WebSocket, TCP, mKCP
- **Features**: UUID-based authentication, multiple encryption

#### VLESS (V2Ray)
- **Port**: 443 (TLS), 80 (non-TLS)  
- **Transport**: WebSocket, TCP, gRPC
- **Features**: Lightweight, high performance

#### TROJAN
- **Port**: 443 (TLS required)
- **Transport**: TCP over TLS
- **Features**: Traffic obfuscation, high security

#### Shadowsocks
- **Port**: Customizable
- **Encryption**: Multiple cipher support
- **Features**: High performance, mobile optimized

## 🎨 UI/UX Features

### Visual Elements
- **Color-coded status** indicators
- **Progress bars** for operations
- **Emoji icons** for better UX
- **Responsive layouts** for different terminals
- **Animation effects** for loading states

### User Experience
- **Intuitive navigation** with numbered menus
- **Error messages** with helpful suggestions
- **Confirmation prompts** for destructive actions
- **Help system** with detailed guides

## 🔧 Advanced Configuration

### Custom Settings
```bash
# Configuration directory
/usr/local/hrstore/config/

# Log files
/var/log/hrstore/

# Data directory
/usr/local/hrstore/data/

# Backup directory
/root/hrstore-backups/
```

### Environment Variables
```bash
# Custom domain
export HRSTORE_DOMAIN="your-domain.com"

# Custom ports
export HRSTORE_SSH_PORT="2222"
export HRSTORE_VMESS_PORT="8443"

# Debug mode
export HRSTORE_DEBUG="true"
```

## 🐛 Troubleshooting

### Common Issues

#### Installation Problems
```bash
# Check system compatibility
./installer.sh --check-system

# Verbose installation
./installer.sh --verbose

# Force reinstall
./installer.sh --force
```

#### Service Issues
```bash
# Check service status
systemctl status hrstore-monitor

# Restart services
systemctl restart xray nginx

# Check logs
tail -f /var/log/hrstore/system.log
```

#### Network Problems
```bash
# Test connectivity
curl -I https://google.com

# Check firewall
ufw status

# Verify ports
netstat -tulpn | grep LISTEN
```

## 📞 Support

### Getting Help
- **Documentation**: Check this README and inline help
- **Logs**: Check `/var/log/hrstore/` for detailed logs
- **Community**: Join our support community
- **Issues**: Report bugs via GitHub issues

### Contact Information
- **Developer**: HR STORE Team
- **Version**: 6.0 Enhanced
- **License**: Custom License
- **Support**: Available for premium users

## 🔄 Changelog

### Version 6.0 Enhanced
- ✨ Complete UI redesign with modern colors and icons
- 🚀 New installer with progress tracking
- 📊 Advanced system monitoring
- 💾 Enhanced backup system with encryption
- 🛡️ Improved security features
- 🎨 Better user experience
- 🔧 Modular architecture
- 📱 Mobile-friendly QR codes

### Previous Versions
- v5.x: Basic VPN management
- v4.x: Multi-protocol support
- v3.x: Web interface
- v2.x: SSH management
- v1.x: Initial release

## 📄 License

This script is proprietary software developed for HR STORE. Unauthorized distribution or modification is prohibited.

## 🙏 Acknowledgments

Special thanks to:
- V2Ray project for excellent protocols
- OpenSSH for secure tunneling
- NGINX for web server capabilities
- The open-source community

---

**© 2024 HR STORE. All rights reserved.**

*Professional VPN Management Made Easy* 🚀

