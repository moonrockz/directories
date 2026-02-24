# Project Agents.md Guide

This is a [MoonBit](https://docs.moonbitlang.com) project.

You can browse and install extra skills here:
<https://github.com/moonbitlang/skills>

## Project Overview

This module (`moonrockz/directories`) is a **standalone library** that provides
platform-specific, user-accessible paths for config, cache, and data directories,
inspired by the [directories-rs](https://codeberg.org/dirs/directories-rs) crate.

It follows XDG base directory spec on Linux, and conventional paths on macOS and
Windows (v1 is env-based; native platform APIs can be added later). The library
**does not create directories or check existence** — it only returns path strings.

### Architecture Summary

```
moonrockz/directories
├── src/                  # The library (sole artifact)
│   ├── lib.mbt           # Package entry point (exports)
│   ├── base_dirs.mbt     # BaseDirs struct + new() + getters
│   ├── user_dirs.mbt     # UserDirs struct + new() + getters
│   ├── project_dirs.mbt   # ProjectDirs struct + from() + getters
│   ├── env.mbt           # Internal: get_env / home_dir resolution
│   ├── path_util.mbt     # Internal: path join
│   ├── *_test.mbt        # Blackbox tests
│   ├── *_wbtest.mbt      # Whitebox tests (if needed)
│   └── moon.pkg          # Package config
├── mise-tasks/           # File-based mise tasks
└── .github/workflows/    # CI and release
```

## Project Structure

- MoonBit packages are organized per directory; `moon.pkg` in each directory
  lists dependencies. The toplevel `moon.mod.json` defines the module.

## Design Philosophy

- **Information only**: No directory creation or existence checks.
- **Option for missing data**: Factory functions return `Option[...]` when home
  (or required env) is missing. Optional dirs (e.g. runtime_dir) return
  `Option[String]`.
- **Immutable snapshot**: Values reflect env at creation time.

## Conventional Commits

All commit messages MUST follow **Conventional Commits**:

```
type(scope): description
```

Types: `feat`, `fix`, `docs`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `style`

Scopes: `core`, `ci`, `build`, etc.

## Mise Tasks

| Task                  | Purpose                                |
|-----------------------|----------------------------------------|
| `test:unit`           | Run unit tests (wasm, wasm-gc, js, native) |
| `release:version`     | Compute next version (conventional)     |
| `release:credentials` | Set up mooncakes.io credentials (CI)   |
| `release:publish`     | Publish package to mooncakes.io       |

Tasks are file-based in `mise-tasks/`. Never add inline `[tasks]` to `.mise.toml`.

## Tooling

- `moon check` — type check
- `moon test` / `mise run test:unit` — run tests on wasm, wasm-gc, js, and native (target-specific behaviour, as in directories-rs). Native requires `libbacktrace-dev` (e.g. `sudo apt install libbacktrace-dev` on Ubuntu).
- `moon fmt` — format
- `moon info` — regenerate `.mbti`; check public API changes

## Platform detection

Build tooling knows only **backend** (js, wasm, wasm-gc, native), not host OS (Windows/Linux/macOS). Runtime OS detection: **moonbitlang/x/path** uses internal FFI for “is Windows?” (JS: `process.platform === "win32"`; native: C stub). See [docs/platform-detection.md](docs/platform-detection.md).

## Release

- Tag `v*` or workflow_dispatch on main triggers release.
- Requires `MOONCAKES_USER_TOKEN` for publish to mooncakes.io.
