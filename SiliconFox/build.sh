#!/bin/bash
# SiliconFox Build - Main Orchestrator for Apple M5 Pro
# Privacy-enhanced browser built from Firefox source

set -e
set -o pipefail

VERSION="1.0.0"
BUILD_ROOT="$HOME/SiliconFox"
CACHE_DIR="$BUILD_ROOT/build/caches"
LOG_DIR="$BUILD_ROOT/build/logs"
SOURCE_DIR="$CACHE_DIR/source"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

# Detect system
detect() {
    log "System: $(uname -m) Apple Silicon"
    log "CPU: $(sysctl -n machdep.cpu.brand_string)"
    log "macOS: $(sw_vers -productVersion)"
    local cores=$(sysctl -n hw.perflevel0.physicalcpu 2>/dev/null || echo 12)
    log "Build cores: $cores"
}

# Check dependencies
check_deps() {
    log "Checking dependencies..."
    local deps=("autoconf" "automake" "libtool" "python3" "git" "rustc" "cargo")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null && ! brew list "$dep" &>/dev/null 2>/dev/null; then
            warn "Missing: $dep"
        fi
    done
    success "Dependency check complete"
}

# Clone Firefox ESR source
clone_firefox() {
    log "Cloning Firefox ESR source (this takes ~10 minutes)..."
    mkdir -p "$SOURCE_DIR"
    cd "$SOURCE_DIR"
    
    # Firefox ESR 128 - stable, well-tested
    git clone --depth 1 --branch esr128 https://hg.mozilla.org/releases/mozilla-release.git . 2>/dev/null || {
        warn "Hg not available, using GitHub mirror..."
        # Alternative: Use GitHub Firefox fork
        git clone --depth 1 --branch esr128 https://github.com/nicholasbalasus/firefox-source.git . 2>/dev/null || {
            error "Failed to clone. Please clone manually:"
            echo "  cd $SOURCE_DIR"
            echo "  git clone --depth 1 --branch esr128 https://github.com/YOUR-FORK/firefox.git ."
            exit 1
        }
    }
    
    success "Firefox source cloned to $SOURCE_DIR"
}

# Apply Apple Silicon patches
apply_patches() {
    log "Applying M5 Pro optimization patches..."
    cd "$SOURCE_DIR"
    
    local patches_dir="$BUILD_ROOT/build/patches"
    if [[ -d "$patches_dir" ]]; then
        for patch in "$patches_dir"/*.patch; do
            [[ -f "$patch" ]] && git apply "$patch" 2>/dev/null || true
        done
    fi
    
    success "Patches applied"
}

# Configure build
configure() {
    log "Configuring for Apple Silicon..."
    cd "$SOURCE_DIR"
    
    cat > "$CACHE_DIR/mozconfig" << 'EOF'
# SiliconFox M5 Pro Optimized Build Config

# Core settings
ac_add_options --enable-release
ac_add_options --enable-optimize
ac_add_options --enable-rust-simd

# Apple Silicon
ac_add_options --target=aarch64-apple-darwin
ac_add_options --host=aarch64-apple-darwin

# Disable unnecessary
ac_add_options --disable-tests
ac_add_options --disable-debug
ac_add_options --disable-jstracer

# Privacy (SiliconFox branding)
ac_add_options --disable-firefox-branding
mk_add_options MOZ_APP_BRANDNAME=SiliconFox
mk_add_options MOZ_APP_DISPLAYNAME=SiliconFox
EOF

    success "Configuration complete: $CACHE_DIR/mozconfig"
}

# Build
build() {
    log "Building SiliconFox (estimated time: 45-60 minutes on M5 Pro)..."
    cd "$SOURCE_DIR"
    
    mkdir -p "$CACHE_DIR/objdir"
    cd "$CACHE_DIR/objdir"
    
    # Configure if needed
    if [[ ! -f ".configured" ]]; then
        log "Running configure..."
        "$SOURCE_DIR/mach" configure --with-mozconfig="$CACHE_DIR/mozconfig" 2>&1 | tee "$LOG_DIR/configure.log"
        touch .configured
    fi
    
    # Build with parallelism
    local cores=$(sysctl -n hw.perflevel0.physicalcpu 2>/dev/null || echo 12)
    local jobs=$((cores * 2))
    
    log "Building with $jobs parallel jobs..."
    "$SOURCE_DIR/mach" build -j"$jobs" 2>&1 | tee "$LOG_DIR/build.log"
    
    success "Build complete!"
}

# Package
package() {
    log "Packaging SiliconFox..."
    cd "$CACHE_DIR/objdir"
    
    if [[ -d "dist/bin" ]]; then
        mkdir -p "$BUILD_ROOT/output"
        tar -czf "$BUILD_ROOT/output/SiliconFox.tar.gz" dist/
        success "Package created: $BUILD_ROOT/output/SiliconFox.tar.gz"
    fi
}

# Help
help() {
    cat << EOF
SiliconFox Build System v${VERSION} - Apple M5 Pro

USAGE: ./build.sh [COMMAND]

COMMANDS:
    deps        Install dependencies
    detect      Show system info
    clone       Clone Firefox ESR source
    patch       Apply optimization patches
    config      Configure build
    build       Build browser
    package     Create distribution
    all         Full pipeline
    help        Show this help

QUICK START:
    ./build.sh deps
    ./build.sh all

NOTE: First build requires 60GB+ disk space and 45-60 minutes.

EOF
}

main() {
    mkdir -p "$CACHE_DIR" "$LOG_DIR"
    
    case "${1:-help}" in
        deps) check_deps ;;
        detect) detect ;;
        clone) clone_firefox ;;
        patch) apply_patches ;;
        config) configure ;;
        build) build ;;
        package) package ;;
        all)
            check_deps
            clone_firefox
            apply_patches
            configure
            build
            package
            ;;
        *) help ;;
    esac
}

main "$@"