///|
/// Internal: resolve environment variables. Uses moonbitlang/x/sys for get_env_var.

///|
/// Returns the value of the environment variable `key`, or None if unset or empty.
fn get_env(key : String) -> String? {
  match @sys.get_env_var(key) {
    Some(v) => if v == "" { None } else { Some(v) }
    None => None
  }
}

///|
/// Returns the user's home directory. On Windows uses USERPROFILE (fallback HOME); elsewhere uses HOME.
fn home_dir() -> String? {
  if is_windows() {
    match get_env("USERPROFILE") {
      Some(p) => Some(p)
      None => get_env("HOME")
    }
  } else {
    get_env("HOME")
  }
}
