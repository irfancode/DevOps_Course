#!/bin/bash
# SiliconFox Dependency Installer
# Installs all required build dependencies for Apple Silicon

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_ROOT="$(dirname "$SCRIPT_DIR")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

check_homebrew() {
    if ! command -v brew &>/dev/null; then
        error "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    log "Homebrew: $(brew --version | head -1)"
}

install_deps() {
    log "Installing build dependencies..."
    
    local deps=(
        autoconf
        automake
        libtool
        pkg-config
        python3
        git
        curl
        wget
        cbindgen
        rust
        llvm
        nasm
        nodejs
        yarn
        go
    )
    
    local to_install=()
    for dep in "${deps[@]}"; do
        if ! brew list "$dep" &>/dev/null; then
            to_install+=("$dep")
        fi
    done
    
    if [[ ${#to_install[@]} -gt 0 ]]; then
        log "Installing: ${to_install[*]}"
        brew install "${to_install[@]}"
    else
        log "All dependencies already installed"
    fi
    
    success "Dependencies ready"
}

setup_rust() {
    log "Configuring Rust for cross-compilation..."
    
    rustup default stable
    rustup update
    
    # Add Apple Silicon targets
    rustup target add aarch64-apple-darwin
    
    # Optimize for M5 Pro
    cat >> ~/.cargo/config.toml << 'EOF' 2>/dev/null || true
[profile.release]
lto = "thin"
codegen-units = 1
opt-level = 3

[build]
target = "aarch64-apple-darwin"
EOF
    
    success "Rust configured for Apple Silicon"
}

setup_apple_sdk() {
    log "Setting up Apple SDK..."
    
    export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
    export MACOSX_DEPLOYMENT_TARGET=$(sw_vers -productVersion | cut -d. -f1,2)
    
    log "SDK: $SDKROOT"
    log "Target: macOS $MACOSX_DEPLOYMENT_TARGET"
}

main() {
    echo "=========================================="
    echo "  SiliconFox Dependency Installer"
    echo "  Apple M5 Pro Optimization"
    echo "=========================================="
    echo
    
    check_homebrew
    install_deps
    setup_rust
    setup_apple_sdk
    
    echo
    echo "=========================================="
    success "Setup complete!"
    echo
    echo "Next steps:"
    echo "  1. cd $BUILD_ROOT"
    echo "  2. ./build.sh clone"
    echo "  3. ./build.sh all"
    echo "=========================================="
}

main "$@"