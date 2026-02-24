# moonrockz/directories

Platform-specific config, cache, and data directory paths for MoonBit. Port of the [directories-rs](https://codeberg.org/dirs/directories-rs) API.

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
    base.home_dir()      // e.g. /home/alice or C:\Users\alice
    base.config_dir()    // e.g. /home/alice/.config or %APPDATA%
    base.cache_dir()     // e.g. /home/alice/.cache or %LOCALAPPDATA%
  }
  None => () // HOME / USERPROFILE not set
}

// ProjectDirs: app-specific paths (qualifier, organization, application)
match @directories.ProjectDirs::from("com", "Foo Corp", "Bar App") {
  Some(proj) => {
    proj.config_dir()    // Linux: .config/bar-app, macOS: Preferences/com.Foo-Corp.Bar-App, Windows: %APPDATA%\Foo Corp\Bar App
    proj.cache_dir()
  }
  None => ()
}

// UserDirs: Desktop, Documents, Downloads, etc.
match @directories.UserDirs::new() {
  Some(u) => u.download_dir()
  None => ()
}
```

## OS-specific behavior

- **Windows:** Home from `USERPROFILE` (fallback `HOME`). Config/roaming from `APPDATA`; cache/data/local from `LOCALAPPDATA`. Path separator `\`. Project path segment: `Organization\Application`.
- **Unix (Linux/macOS):** Home from `HOME`. Paths from `XDG_*` when set, else `$HOME/.config`, `.cache`, `.local/share`, etc. Path separator `/`. Linux project path: single lowercase segment; macOS: `qualifier.Organization.Application`.

On Windows, `config_dir()` and `config_local_dir()` differ (roaming vs local); on Unix they are the same in v1.

## Path utilities and platform

```mbt nocheck
@directories.path_sep()   // "\\" on Windows, "/" on Unix
@directories.join(["home", "alice", ".config"])  // OS-native path
@directories.platform()   // Platform::Windows | Linux | Darwin | Unknown
@directories.is_windows() // true on Windows
```

Use `join()` and `path_sep()` when building or displaying paths so they match the current OS.

## API

- **BaseDirs::new()** → `Option[BaseDirs]`: home_dir, cache_dir, config_dir, config_local_dir, data_dir, data_local_dir, preference_dir; optional executable_dir, runtime_dir, state_dir.
- **UserDirs::new()** → `Option[UserDirs]`: home_dir plus optional audio_dir, desktop_dir, document_dir, download_dir, font_dir, picture_dir, public_dir, template_dir, video_dir.
- **ProjectDirs::from(qualifier, organization, application)** → `Option[ProjectDirs]`: project_path plus cache_dir, config_dir, config_local_dir, data_dir, data_local_dir, preference_dir; optional runtime_dir, state_dir.
- **join(segments)** → path string with OS separator; **path_sep()** → current separator; **platform()** / **is_windows()** / **Platform** for OS detection.

v1 resolves paths from environment variables (HOME, USERPROFILE, APPDATA, LOCALAPPDATA, XDG_*). Native platform APIs may be added in a later version.

## Development

Tests run on all supported targets: `mise run test:unit` (wasm, wasm-gc, js, native). On Linux, the **native** target requires `libbacktrace-dev` (e.g. `sudo apt install libbacktrace-dev` on Ubuntu/Debian).
