///|
/// Runtime OS detection via FFI. Use when you need to branch on Windows / Linux / macOS.

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
  0
}

///|
#cfg(target="native")
extern "c" fn platform_kind_raw() -> Int = "moonrockz_directories_platform_kind"

///|
pub enum Platform {
  Windows
  Linux
  Darwin
  Unknown
}

///|
fn platform_from_kind(kind : Int) -> Platform {
  match kind {
    1 => Platform::Windows
    2 => Platform::Linux
    3 => Platform::Darwin
    _ => Platform::Unknown
  }
}

///|
/// Returns the current OS platform at runtime (Windows, Linux, Darwin, or Unknown).
/// Implemented via FFI per target: JS uses process.platform; native uses C preprocessor macros.
pub fn platform() -> Platform {
  platform_from_kind(platform_kind_raw())
}

///|
/// Convenience: true if platform is Windows.
pub fn is_windows() -> Bool {
  platform() is Platform::Windows
}
