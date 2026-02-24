///|
/// Runtime OS detection via FFI. Use when you need to branch on Windows / Linux / macOS.
/// Raw kind values match native_stub.c PLATFORM_KIND_* (0=Unknown, 1=Windows, 2=Linux, 3=Darwin).

///|
let platform_kind_unknown : Int = 0

///|
let platform_kind_windows : Int = 1

///|
let platform_kind_linux : Int = 2

///|
let platform_kind_darwin : Int = 3

///|
#cfg(target="js")
extern "js" fn platform_kind_raw() -> Int =
  #|function () {
  #|  let process = require("process");
  #|  switch (process.platform) {
  #|    case "win32": return 1;
  #|    case "linux": return 2;
  #|    case "darwin": return 3;
  #|    default: return 0;
  #|  }
  #|};
  #|

///|
#cfg(any(target="wasm", target="wasm-gc"))
fn platform_kind_raw() -> Int {
  platform_kind_unknown
}

///|
#cfg(target="native")
extern "c" fn platform_kind_raw() -> Int = "moonrockz_directories_platform_kind"

///|
/// Runtime operating system: Windows, Linux, macOS (Darwin), or Unknown.
/// Use with `platform()` to branch on OS (e.g. path rules, UI defaults).
pub enum Platform {
  Windows
  Linux
  Darwin
  Unknown
}

///|
fn platform_from_kind(kind : Int) -> Platform {
  match kind {
    k if k == platform_kind_windows => Platform::Windows
    k if k == platform_kind_linux => Platform::Linux
    k if k == platform_kind_darwin => Platform::Darwin
    _ => Platform::Unknown
  }
}

///|
/// Returns the current OS at runtime: `Platform::Windows`, `Linux`, `Darwin`, or `Unknown`.
/// JS target uses `process.platform`; native uses C preprocessor (_WIN32, __APPLE__, __linux__).
///
/// Example: `match platform() { Platform::Windows => ... ; Platform::Darwin => ... ; _ => ... }`
pub fn platform() -> Platform {
  platform_from_kind(platform_kind_raw())
}

///|
/// Returns `true` when the current OS is Windows, `false` otherwise.
/// Use for path separator, HOME vs USERPROFILE, or Windows-specific APIs.
///
/// Example: `if is_windows() { "\\" } else { "/" }`
pub fn is_windows() -> Bool {
  platform() is Platform::Windows
}
