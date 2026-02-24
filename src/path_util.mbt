///|
/// Returns the path separator for the current OS: `"\\"` on Windows, `"/"` on Unix.
/// Use when building or displaying OS-native paths.
///
/// Example: `path_sep()` → `"\\"` on Windows, `"/"` on Linux/macOS.
pub fn path_sep() -> String {
  if is_windows() {
    "\\"
  } else {
    "/"
  }
}

///|
/// Internal: join two parts with the given separator.
fn join_two_with(sep : String, acc : String, seg : String) -> String {
  if seg == "" {
    acc
  } else if acc == "" {
    seg
  } else {
    acc + sep + seg
  }
}

///|
/// Joins path segments using the current OS separator. Empty segments are skipped.
/// On Windows uses `\\`; on Unix uses `/`.
///
/// Example: `join(["home", "alice", ".config"])` → `"home/alice/.config"` on Unix,
/// `"home\\alice\\.config"` on Windows.
pub fn join(segments : Array[String]) -> String {
  let sep = path_sep()
  segments.fold(init="", (acc, seg) => join_two_with(sep, acc, seg))
}
