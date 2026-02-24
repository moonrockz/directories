///|
/// Internal path helpers. Joins segments with "/"; no trailing slash.
fn join_two(acc : String, seg : String) -> String {
  if seg is "" {
    acc
  } else if acc is "" {
    seg
  } else {
    acc + "/" + seg
  }
}

///|
/// Join path segments. Empty segments are skipped; non-empty are joined with "/".
pub fn join(segments : Array[String]) -> String {
  segments.fold(init="", join_two)
}
