# moonrockz/directories

Platform-specific config, cache, and data directory paths for MoonBit (XDG on Linux, conventions on macOS/Windows). Port of the [directories-rs](https://codeberg.org/dirs/directories-rs) API.

**Information only** — this library does not create directories or check existence.

## Installation

```bash
moon add moonrockz/directories
```

## Quick Start

```mbt nocheck
// BaseDirs: user-level cache, config, data paths
match @directories.BaseDirs::new() {
  Some(base) => {
    base.home_dir()      // e.g. /home/alice
    base.config_dir()    // e.g. /home/alice/.config
    base.cache_dir()     // e.g. /home/alice/.cache
  }
  None => () // HOME not set
}

// ProjectDirs: app-specific paths
match @directories.ProjectDirs::from("com", "Foo Corp", "Bar App") {
  Some(proj) => {
    proj.config_dir()    // e.g. /home/alice/.config/barapp
    proj.cache_dir()
  }
  None => ()
}
```

## API

- **BaseDirs::new()** → `Option[BaseDirs]`: home, cache_dir, config_dir, config_local_dir, data_dir, data_local_dir, preference_dir; optional executable_dir, runtime_dir, state_dir.
- **UserDirs::new()** → `Option[UserDirs]`: home_dir plus optional audio, desktop, document, download, font, picture, public, template, video dirs.
- **ProjectDirs::from(qualifier, organization, application)** → `Option[ProjectDirs]`: project-scoped cache, config, data, etc.

v1 resolves paths from environment variables (HOME, XDG_* on Linux). Native platform APIs may be added in a later version.

## Development

Tests run on all supported targets: `mise run test:unit` (wasm, wasm-gc, js, native). On Linux, the **native** target requires `libbacktrace-dev` (e.g. `sudo apt install libbacktrace-dev` on Ubuntu/Debian).
