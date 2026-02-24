///|
/// BaseDirs: user-invisible standard directories (cache, config, data, etc.).
/// Follows XDG on Linux; v1 uses env vars only.
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
/// Create BaseDirs from current environment. Returns None if home is not set.
/// On Windows uses LOCALAPPDATA/APPDATA; on Unix uses XDG_* or $HOME subdirs.
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

///|
pub fn BaseDirs::home_dir(self : BaseDirs) -> String {
  self.home_dir
}

///|
pub fn BaseDirs::cache_dir(self : BaseDirs) -> String {
  self.cache_dir
}

///|
pub fn BaseDirs::config_dir(self : BaseDirs) -> String {
  self.config_dir
}

///|
pub fn BaseDirs::config_local_dir(self : BaseDirs) -> String {
  self.config_local_dir
}

///|
pub fn BaseDirs::data_dir(self : BaseDirs) -> String {
  self.data_dir
}

///|
pub fn BaseDirs::data_local_dir(self : BaseDirs) -> String {
  self.data_local_dir
}

///|
pub fn BaseDirs::executable_dir(self : BaseDirs) -> String? {
  self.executable_dir
}

///|
pub fn BaseDirs::preference_dir(self : BaseDirs) -> String {
  self.preference_dir
}

///|
pub fn BaseDirs::runtime_dir(self : BaseDirs) -> String? {
  self.runtime_dir
}

///|
pub fn BaseDirs::state_dir(self : BaseDirs) -> String? {
  self.state_dir
}
