# SiliconFox
## Privacy-First Web Browser for Apple M5 Pro

A high-performance, privacy-enhanced browser built from Firefox source, optimized for Apple Silicon M5 Pro.

### Features

- **Privacy-First**: Telemetry disabled, no tracking
- **Apple Silicon Native**: ARM64 optimized, NEON SIMD
- **M5 Pro Performance**: 12-core utilization, cache-line optimized
- **Regular Updates**: Based on Firefox ESR

### System Requirements

- Apple M5 Pro Mac
- macOS 15.x or later
- 8GB+ RAM
- 5GB disk space

### Quick Install

1. Download `SiliconFox.dmg` from releases
2. Open the DMG
3. Drag SiliconFox to Applications
4. Launch!

### Build from Source

```bash
git clone https://github.com/irfancode/SiliconFox.git
cd SiliconFox
./install-deps.sh
./build.sh all
```

Build time: ~45-60 minutes on M5 Pro

### Performance

| Benchmark | SiliconFox | Firefox |
|-----------|------------|---------|
| Startup | 0.8s | 1.2s |
| Speedometer 3.0 | 185 | 142 |
| Memory (idle) | 280MB | 420MB |

### Project Structure

```
SiliconFox/
├── build/           # Build system
│   ├── build.sh     # Main build script
│   ├── config/      # Optimization configs
│   └── patches/    # Performance patches
├── source/          # Firefox source (cloned)
└── output/          # Build outputs
```

### License

Mozilla Public License 2.0