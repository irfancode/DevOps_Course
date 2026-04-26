#!/bin/bash
# SiliconFox Build Status Checker

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_ROOT="$(dirname "$SCRIPT_DIR")"
CACHE_DIR="$BUILD_ROOT/caches"
LOG_DIR="$BUILD_ROOT/logs"
SOURCE_DIR="$CACHE_DIR/source"

check_system() {
    echo -e "${CYAN}=== System Information ===${NC}"
    echo "Hardware: $(sysctl -n hw.model)"
    echo "CPU: $(sysctl -n machdep.cpu.brand_string)"
    echo "CPU Cores: $(sysctl -n hw.perflevel0.physicalcpu 2>/dev/null || sysctl -n hw.physicalcpu)"
    echo "Memory: $(sysctl -n hw.memsize | awk '{printf "%.2f GB", $1/1024/1024/1024}')"
    echo "macOS: $(sw_vers -productVersion)"
    echo
}

check_source() {
    echo -e "${CYAN}=== Source Code Status ===${NC}"
    if [[ -d "$SOURCE_DIR" ]]; then
        echo "Source: ${GREEN}Present${NC}"
        cd "$SOURCE_DIR"
        echo "Branch: $(git branch --show-current)"
        echo "Commit: $(git rev-parse --short HEAD)"
        echo "Last fetch: $(git log -1 --format='%cr' HEAD 2>/dev/null || echo 'Unknown')"
    else
        echo "Source: ${YELLOW}Not cloned${NC} - Run './build.sh clone'"
    fi
    echo
}

check_build() {
    echo -e "${CYAN}=== Build Status ===${NC}"
    
    if [[ -d "$CACHE_DIR/objdir" ]]; then
        if [[ -f "$CACHE_DIR/objdir/.configured" ]]; then
            echo "Configure: ${GREEN}Complete${NC}"
        else
            echo "Configure: ${YELLOW}Pending${NC}"
        fi
        
        if [[ -f "$CACHE_DIR/objdir/dist/bin/SiliconFox" ]]; then
            echo "Build: ${GREEN}Complete${NC}"
            ls -lh "$CACHE_DIR/objdir/dist/bin/SiliconFox" 2>/dev/null | awk '{print "Binary size:", $5}'
        else
            echo "Build: ${YELLOW}Pending/Running${NC}"
        fi
    else
        echo "Build: ${YELLOW}Not started${NC}"
    fi
    echo
}

check_package() {
    echo -e "${CYAN}=== Package Status ===${NC}"
    
    if [[ -f "$BUILD_ROOT/SiliconFox.dmg" ]]; then
        echo "DMG: ${GREEN}Ready${NC}"
        ls -lh "$BUILD_ROOT/SiliconFox.dmg" | awk '{print "Size:", $5}'
    else
        echo "DMG: ${YELLOW}Not created${NC}"
    fi
    
    if [[ -d "$BUILD_ROOT/SiliconFox.app" ]]; then
        echo "App: ${GREEN}Built${NC}"
    else
        echo "App: ${YELLOW}Not built${NC}"
    fi
    echo
}

check_logs() {
    echo -e "${CYAN}=== Recent Build Logs ===${NC}"
    if [[ -f "$LOG_DIR/build.log" ]]; then
        echo "Last 10 log entries:"
        tail -10 "$LOG_DIR/build.log" | sed 's/^/  /'
    else
        echo "No build logs found"
    fi
    echo
}

check_disk() {
    echo -e "${CYAN}=== Disk Usage ===${NC}"
    echo "Source: $(du -sh "$SOURCE_DIR" 2>/dev/null | cut -f1 || echo 'N/A')"
    echo "Objdir: $(du -sh "$CACHE_DIR/objdir" 2>/dev/null | cut -f1 || echo 'N/A')"
    echo "Total caches: $(du -sh "$CACHE_DIR" 2>/dev/null | cut -f1 || echo 'N/A')"
    echo
}

main() {
    clear
    echo "=========================================="
    echo "  SiliconFox Build Status Monitor"
    echo "  M5 Pro Apple Silicon"
    echo "=========================================="
    echo
    
    check_system
    check_source
    check_build
    check_package
    check_disk
    check_logs
    
    echo "=========================================="
    echo "Last checked: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "=========================================="
}

main "$@"

# Auto-refresh if requested
if [[ "$1" == "--watch" || "$1" == "-w" ]]; then
    while true; do
        clear
        main
        sleep 5
    done
fi