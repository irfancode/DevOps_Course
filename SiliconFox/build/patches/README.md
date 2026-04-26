# SiliconFox Patches

This directory contains optimization patches for Apple Silicon (M5 Pro).

## Available Patches

### arm64-optimizations.patch
- Enables NEON SIMD instructions
- Optimizes for Apple Silicon cache hierarchy
- Enables pointer authentication

### m5-pro-performance.patch
- Adjusts thread affinity for performance cores
- Optimizes memory allocation for M5 Pro
- Enables high-performance GPU scheduling

### privacy-enhancements.patch
- Removes telemetry endpoints
- Disables crash reporting
- Hardens privacy settings

## Applying Patches

```bash
cd ~/SiliconFox/build/caches/source
git apply ../../../config/patches/arm64-optimizations.patch
```

## Creating Custom Patches

```bash
cd source
# Make your changes
git diff > ../config/patches/my-custom-patch.patch
```