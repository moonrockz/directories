# moonrockz/directories

[![CI](https://github.com/moonrockz/directories/actions/workflows/ci.yml/badge.svg)](https://github.com/moonrockz/directories/actions/workflows/ci.yml)

Platform-specific config, cache, and data directory paths for
[MoonBit](https://www.moonbitlang.com). A port of the
[directories-rs](https://codeberg.org/dirs/directories-rs) API.

This file is about the repository and how to develop it. For the library
documentation (API, examples, OS-specific behavior), see
[README.mbt.md](README.mbt.md). The same file is the package README on
[mooncakes.io](https://mooncakes.io/docs/moonrockz/directories).

## Package

| Item       | Value                                       |
|------------|---------------------------------------------|
| Module     | `moonrockz/directories`                     |
| Source     | `src/`                                      |
| Registry   | [mooncakes.io](https://mooncakes.io)        |
| Targets    | wasm, wasm-gc, js, native                   |
| License    | Apache-2.0                                  |

Install it in a MoonBit project:

```bash
moon add moonrockz/directories
```

## Development

### Prerequisites

- [mise](https://mise.jdx.dev). It holds the project config and all tasks in
  `.config/mise/`.
- On Linux, the **native** target needs `libbacktrace-dev`
  (for example, `sudo apt install libbacktrace-dev` on Ubuntu or Debian).

### MoonBit toolchain

The MoonBit toolchain version is pinned in `.config/mise/config.toml` as
`MOONBIT_INSTALL_VERSION`. This is the only place that sets it. Local setup
and CI both read it.

Show the pinned version:

```bash
mise exec -- printenv MOONBIT_INSTALL_VERSION
```

Show the installed version:

```bash
moon version --all
```

Install the pinned version to `~/.moon`:

```bash
mise install            # runs setup:moonbit as a postinstall hook
mise run setup:moonbit  # or run the task directly
```

If the hook fails, `mise install` shows only a warning. The task does nothing if the pinned version is already installed. It
replaces the toolchain in `~/.moon`, so it changes `moon` for all projects
on your machine.

To upgrade, change `MOONBIT_INSTALL_VERSION` to the new `moonc -v` version
(without the date, for example `0.10.15+943464bfa`). Then run
`mise run setup:moonbit` and `mise run test:unit`.

### Tasks

| Task                  | Purpose                                         |
|-----------------------|-------------------------------------------------|
| `setup:moonbit`       | Install the pinned MoonBit toolchain            |
| `test:unit`           | Run unit tests (wasm, wasm-gc, js, native)      |
| `release:version`     | Compute the next version from the commits       |
| `release:credentials` | Set up mooncakes.io credentials (CI)            |
| `release:publish`     | Publish the package to mooncakes.io             |

Tasks are file-based scripts in `.config/mise/tasks/`. Run `mise tasks ls` to
list them.

### Common commands

```bash
moon update            # fetch dependencies
moon check             # type check
moon fmt               # format (CI fails if this changes files)
moon info              # regenerate src/pkg.generated.mbti
mise run test:unit     # test on all targets
```

## Contributing

Commit messages use
[Conventional Commits](https://www.conventionalcommits.org) (`type(scope): description`).
CI runs format, check, and tests on Linux, macOS, and Windows.

## Releases

The `Release` workflow publishes to mooncakes.io. It runs when a `v*` tag is
pushed, or when started by hand from `main`.

## License

Apache-2.0
