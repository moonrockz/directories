///|
/// Standard directories for cache, config, data, and related paths (user-level, not app-specific).
/// On **Windows:** config/roaming from APPDATA, local/cache/data from LOCALAPPDATA.
/// On **Unix:** XDG_* when set, else \$HOME/.config, .cache, .local/share, .local/state.
pub struct BaseDirs {
  home_dir : String
  cache_dir : String
  config_dir : String
  config_local_dir : String
  data_dir : String
  data_local_dir : String
  executable_dir : String?
  preference_dir : String
  runtime_dir : String?
  state_dir : String?
}

///|
fn base_dirs_unix(home : String) -> BaseDirs {
  let config = match get_env("XDG_CONFIG_HOME") {
    Some(c) => c
    None => join([home, ".config"])
  }
  let cache = match get_env("XDG_CACHE_HOME") {
    Some(c) => c
    None => join([home, ".cache"])
  }
  let data = match get_env("XDG_DATA_HOME") {
    Some(d) => d
    None => join([home, ".local", "share"])
  }
  let state = match get_env("XDG_STATE_HOME") {
    Some(s) => s
    None => join([home, ".local", "state"])
  }
  let exec_dir = match get_env("XDG_BIN_HOME") {
    Some(b) => Some(b)
    None => Some(join([home, ".local", "bin"]))
  }
  let runtime = get_env("XDG_RUNTIME_DIR")
  BaseDirs::{
    home_dir: home,
    cache_dir: cache,
    config_dir: config,
    config_local_dir: config,
    data_dir: data,
    data_local_dir: data,
    executable_dir: exec_dir,
    preference_dir: config,
    runtime_dir: runtime,
    state_dir: Some(state),
  }
}

///|
fn base_dirs_windows(home : String) -> BaseDirs {
  let local_app_data = match get_env("LOCALAPPDATA") {
    Some(p) => p
    None => join([home, "AppData", "Local"])
  }
  let roaming = match get_env("APPDATA") {
    Some(p) => p
    None => join([home, "AppData", "Roaming"])
  }
  BaseDirs::{
    home_dir: home,
    cache_dir: local_app_data,
    config_dir: roaming,
    config_local_dir: local_app_data,
    data_dir: local_app_data,
    data_local_dir: local_app_data,
    executable_dir: None,
    preference_dir: roaming,
    runtime_dir: None,
    state_dir: None,
  }
}

///|
/// Creates BaseDirs from the current environment. Returns `None` if home is not set
/// (HOME on Unix, USERPROFILE or HOME on Windows).
///
/// Example:
///   match BaseDirs::new() {
///     Some(base) => base.cache_dir()  // e.g. /home/alice/.cache or %LOCALAPPDATA%
///     None => ...
///   }
pub fn BaseDirs::new() -> BaseDirs? {
  match home_dir() {
    Some(home) =>
      Some(
        if is_windows() {
          base_dirs_windows(home)
        } else {
          base_dirs_unix(home)
        },
      )
    None => None
  }
}

///| User home directory (e.g. /home/alice or C:\Users\alice).
pub fn BaseDirs::home_dir(self : BaseDirs) -> String {
  self.home_dir
}

///| Cache directory (e.g. .cache on Unix, LOCALAPPDATA on Windows).
pub fn BaseDirs::cache_dir(self : BaseDirs) -> String {
  self.cache_dir
}

///| Config directory (roaming on Windows: APPDATA; Unix: XDG_CONFIG_HOME or .config).
pub fn BaseDirs::config_dir(self : BaseDirs) -> String {
  self.config_dir
}

///| Local config directory (LOCALAPPDATA on Windows; same as config_dir on Unix).
pub fn BaseDirs::config_local_dir(self : BaseDirs) -> String {
  self.config_local_dir
}

///| Data directory (e.g. .local/share on Unix, LOCALAPPDATA on Windows).
pub fn BaseDirs::data_dir(self : BaseDirs) -> String {
  self.data_dir
}

///| Local data directory (same as data_dir on both platforms in v1).
pub fn BaseDirs::data_local_dir(self : BaseDirs) -> String {
  self.data_local_dir
}

///| User executables directory (XDG_BIN_HOME or .local/bin on Unix); None on Windows.
pub fn BaseDirs::executable_dir(self : BaseDirs) -> String? {
  self.executable_dir
}

///| Preference/settings directory (same as config_dir on Unix; APPDATA on Windows).
pub fn BaseDirs::preference_dir(self : BaseDirs) -> String {
  self.preference_dir
}

///| Runtime directory (XDG_RUNTIME_DIR on Unix); None on Windows.
pub fn BaseDirs::runtime_dir(self : BaseDirs) -> String? {
  self.runtime_dir
}

///| State directory (XDG_STATE_HOME or .local/state on Unix); None on Windows.
pub fn BaseDirs::state_dir(self : BaseDirs) -> String? {
  self.state_dir
}
