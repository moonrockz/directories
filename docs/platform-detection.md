# Platform / OS detection in MoonBit

How the tooling, core, and x libraries let you know whether you're on Windows, Linux, macOS, or another target.

## Build-time: backend only, no host OS

**The build system does not expose host OS** (windows/linux/macos). It only exposes the **backend/target**:

- **Conditional compilation** uses `#cfg(target="...")` with backend values: `js`, `wasm`, `wasm-gc`, `native`, (and possibly `llvm`).
- **Package config** (`moon.pkg.json` / `targets`) can restrict which files are compiled for which backends (e.g. `"only_js.mbt": ["js"]`).
- There is **no** `target_os`, `cfg(windows)`, or `cfg(linux)` in the language or in `moon` package config.

So at **build time** you can only branch on backend (e.g. “native” vs “js”), not on “Windows” vs “Linux” vs “macOS”. The same `native` build can run on any host OS; the compiler does not pass host OS into the build.

References: [MoonBit package configuration](https://docs.moonbitlang.com/en/latest/toolchain/moon/package.html) (`targets`), [cfg attribute](https://docs.moonbitlang.com/en/latest/language/docs) (`#cfg(target="wasm")`, etc.).

## Runtime: OS detection via moonbitlang/x

**At runtime**, you can detect the operating system using **moonbitlang/x**:

### 1. **moonbitlang/x/path** — `is_windows()`

The **path** package’s internal FFI exposes **Windows vs non-Windows**:

- **JS**: `process.platform === "win32"` (Node.js).
- **wasm / wasm-gc**: host via `__moonbit_sys_unstable` `"is_windows"`.
- **native**: C symbol `moonbitlang_x_path_is_windows` (typically implemented with `#ifdef _WIN32` in the native stub).

The path package uses this internally (e.g. for `Path::sep` and `Path::delimiter`). The **path** API does not export a standalone `is_windows()`; it’s used inside the package. To get the same “Windows vs not” in your code you can:

- Depend on **moonbitlang/x/path** and use **`Path::sep`** or **`Path::delimiter`** to infer (e.g. `';'` and `'\\'` vs `':'` and `'/'`), or
- Reuse the same pattern: implement a small FFI that calls `process.platform` (JS), the wasm host API, or a native C stub with `#ifdef _WIN32`.

So in practice: **runtime “are we on Windows?”** is supported via x’s path internals; **“Linux vs macOS”** is not a dedicated API in core or x — you’d infer it (e.g. from env like `HOME` containing `"/Users/"` for macOS, or from a custom FFI / env var).

### 2. **moonbitlang/x/sys** — environment variables

**moonbitlang/x/sys** provides **`get_env_var`** / **`get_env_vars`**. You can use env vars to infer OS when the host sets them, e.g.:

- **Windows**: often `APPDATA`, `LOCALAPPDATA`, `USERPROFILE`, or `OS` set by the shell/IDE.
- **CI**: e.g. `OS_PLATFORM` or `RUNNER_OS` (GitHub Actions) to know “windows-latest”, “linux”, “macOS”.

So: **build tooling does not know “Windows/Linux/macOS”**; only backend (js/wasm/native). **Runtime** can know “Windows vs not” via x’s path logic (or your own FFI), and “Linux vs macOS vs Windows” via env vars when the environment provides them.

## Summary

| Question | Answer |
|----------|--------|
| Can the **build** know Windows / Linux / macOS? | **No.** Only backend: `js`, `wasm`, `wasm-gc`, `native` (and possibly `llvm`). |
| Can **runtime** know “Windows”? | **Yes**, via moonbitlang/x/path’s internal FFI (or your own JS/native FFI mirroring it). |
| Can **runtime** know “Linux” vs “macOS”? | Not via a dedicated core/x API; infer from env (e.g. `HOME`, CI vars) or custom FFI. |
| Where is this used in x? | **path**: `is_windows` drives `Path::sep`, `Path::delimiter`, and win32 vs posix path behavior. |

For **moonrockz/directories**, we currently infer platform from env (`APPDATA`/`LOCALAPPDATA` for Windows, `HOME` containing `"/Users/"` for macOS, else Linux-style). We could later add a dependency on **moonbitlang/x/path** and use path’s behavior (or a re-export of “is Windows”) for more reliable Windows detection if needed.
