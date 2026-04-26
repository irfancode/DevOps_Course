# SiliconFox Build Guide
## Optimized for Apple M5 Pro Apple Silicon

### Table of Contents
1. [Prerequisites](#prerequisites)
2. [Quick Start](#quick-start)
3. [Detailed Build Steps](#detailed-build-steps)
4. [Build Options](#build-options)
5. [Troubleshooting](#troubleshooting)
6. [Performance Tuning](#performance-tuning)

---

## Prerequisites

### Hardware
- Apple M5 Pro Mac (12-core CPU / 24GB+ unified memory recommended)
- 100GB+ free disk space for build artifacts
- Stable internet connection

### Software
- macOS 15.x (Sonoma or later)
- Xcode 16.x command line tools
- Homebrew

---

## Quick Start

```bash
# 1. Clone this repository
git clone https://github.com/irfancode/SiliconFox.git
cd SiliconFox

# 2. Install dependencies
./install-deps.sh

# 3. Run full build
./build.sh all

# 4. Launch SiliconFox
open SiliconFox.dmg
```

**Build time on M5 Pro: ~45-60 minutes**

---

## Detailed Build Steps

### Step 1: Install Dependencies

```bash
./install-deps.sh
```

This installs:
- autoconf, automake, libtool
- Rust (with aarch64-apple-darwin target)
- LLVM/Clang
- Python 3
- All required build tools

### Step 2: Clone Firefox Source

```bash
./build.sh clone
```

This clones the Firefox ESR source tree (~3GB).

### Step 3: Apply Patches

```bash
./build.sh patch
```

Applies Apple Silicon optimizations.

### Step 4: Configure Build

```bash
./build.sh config
```

Generates optimized `.mozconfig` for M5 Pro.

### Step 5: Build

```bash
./build.sh build
```

- Uses all M5 Pro cores
- Compile time: 45-60 minutes
- Progress logged to `logs/build.log`

### Step 6: Package

```bash
./build.sh package
```

Creates `SiliconFox.dmg` for distribution.

---

## Build Options

### Environment Variables

```bash
# Number of parallel jobs (default: auto-detect)
export MACH_JOBS=24

# Enable ccache for faster rebuilds
export USE_CCACHE=1

# Enable mold linker (faster linking)
export LD=/opt/homebrew/bin/mold
```

### Build Targets

```bash
# Debug build (faster, larger binary)
MOZ_DEBUG=1 ./build.sh build

# Release build (optimized, smaller)
MOZ_RELEASE=1 ./build.sh build

# Profile-guided optimization
MOZ_PGO=1 ./build.sh build
```

---

## Troubleshooting

### Error: Missing autoconf
```bash
brew install autoconf automake libtool
```

### Error: Rust target not found
```bash
rustup target add aarch64-apple-darwin
```

### Error: LLVM not found
```bash
brew install llvm
export LDFLAGS="-L$(brew --prefix llvm)/lib"
export CPPFLAGS="-I$(brew --prefix llvm)/include"
```

### Build fails at JavaScript engine
This is normal on first build. It compiles SpiderMonkey which takes 15+ minutes.

### Build out of memory
Reduce parallel jobs:
```bash
MACH_JOBS=8 ./build.sh build
```

### Permission denied errors
```bash
sudo xcode-select --install
sudo chown -R $(whoami) /usr/local/share
```

---

## Performance Tuning

### M5 Pro Optimizations

| Setting | Value | Benefit |
|---------|-------|---------|
| Parallel Jobs | 24 | Full core utilization |
| LTO | thin | Faster linking |
| Cache Line | 128 bytes | M5 Pro optimal |
| SIMD | NEON | Hardware acceleration |
| Pointer Auth | Enabled | Security + performance |

### Post-Build Optimization

After build, create optimized package:
```bash
./build.sh package

# Sign for development
codesign -f -s -v SiliconFox.app

# Notarize for distribution
x notarytool submit SiliconFox.dmg
```

### Benchmarking

```bash
# Measure startup time
time ./SiliconFox.app/Contents/MacOS/siliconfox --headless

# Measure page load
./SiliconFox.app/Contents/MacOS/siliconfox \
  --browser-startup-url=https://browserbench.org/speedometer3.0
```

---

## Project Structure

```
SiliconFox/
├── build/
│   ├── build.sh          # Main build orchestrator
│   ├── install-deps.sh    # Dependency installer
│   ├── status.sh         # Build status monitor
│   ├── config/
│   │   ├── Info.plist    # App configuration
│   │   └── mozconfig     # Firefox build config
│   ├── patches/
│   │   ├── arm64-optimizations.patch
│   │   ├── m5-pro-performance.patch
│   │   └── privacy-enhancements.patch
│   ├── caches/
│   │   └── source/       # Firefox source code
│   └── logs/
│       └── build.log     # Build logs
└── SiliconFox.dmg        # Output package
```

---

## Contributing

1. Fork the repository
2. Create a feature branch
3. Apply patches and test
4. Submit pull request

---

## License

Based on Mozilla Firefox source code. Licensed under MPL 2.0.

---

**Built with ❤️ for Apple Silicon**