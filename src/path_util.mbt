///|
/// Path separator for the current OS: "\\" on Windows, "/" otherwise.
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
/// Join path segments for the current OS. Empty segments are skipped.
/// Uses platform path separator (\\ on Windows, / on Unix).
pub fn join(segments : Array[String]) -> String {
  let sep = path_sep()
  segments.fold(init="", (acc, seg) => join_two_with(sep, acc, seg))
}
