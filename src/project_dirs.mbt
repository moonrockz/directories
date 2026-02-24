///|
/// ProjectDirs: project-scoped cache, config, data paths.
/// Path segment rules: Linux (single lowercase segment), macOS (qualifier.Org-App), Windows (Org/App).
pub struct ProjectDirs {
  project_path : String
  cache_dir : String
  config_dir : String
  config_local_dir : String
  data_dir : String
  data_local_dir : String
  preference_dir : String
  runtime_dir : String?
  state_dir : String?
}

///|
fn join_hyphen(parts : Array[String]) -> String {
  parts.fold(init="", (acc, p) => if acc == "" { p } else { acc + "-" + p })
}

///|
fn replace_space_with_hyphen(s : String) -> String {
  let parts = s.split(" ").map(v => v.to_string()).collect()
  join_hyphen(parts)
}

///|
fn project_path_linux(
  _qualifier : String,
  _organization : String,
  application : String,
) -> String {
  let lower = application[:].to_lower().to_string()
  replace_space_with_hyphen(lower)
}

///|
fn project_path_macos(
  qualifier : String,
  organization : String,
  application : String,
) -> String {
  let q = if qualifier == "" { "" } else { qualifier + "." }
  let org_s = replace_space_with_hyphen(organization)
  let app_s = replace_space_with_hyphen(application)
  if org_s == "" {
    q + app_s
  } else {
    q + org_s + "." + app_s
  }
}

///|
fn project_path_windows(
  _qualifier : String,
  organization : String,
  application : String,
) -> String {
  if organization == "" {
    application
  } else {
    organization + "/" + application
  }
}

///|
/// Detect platform from env: Windows if APPDATA or LOCALAPPDATA; else macOS if HOME contains "/Users/"; else Linux.
fn project_path_segment(
  qualifier : String,
  organization : String,
  application : String,
) -> String {
  if get_env("APPDATA") is Some(_) || get_env("LOCALAPPDATA") is Some(_) {
    project_path_windows(qualifier, organization, application)
  } else {
    match home_dir() {
      Some(home) =>
        if home.contains("/Users/") {
          project_path_macos(qualifier, organization, application)
        } else {
          project_path_linux(qualifier, organization, application)
        }
      None => project_path_linux(qualifier, organization, application)
    }
  }
}

///|
fn opt_join(prefix : String?, seg : String) -> String? {
  match prefix {
    Some(p) => Some(join([p, seg]))
    None => None
  }
}

///|
/// Create ProjectDirs from qualifier, organization, application. Returns None if HOME (or base dirs) unavailable.
pub fn ProjectDirs::from(
  qualifier : String,
  organization : String,
  application : String,
) -> ProjectDirs? {
  match BaseDirs::new() {
    Some(base) => {
      let seg = project_path_segment(qualifier, organization, application)
      Some(ProjectDirs::{
        project_path: seg,
        cache_dir: join([base.cache_dir(), seg]),
        config_dir: join([base.config_dir(), seg]),
        config_local_dir: join([base.config_local_dir(), seg]),
        data_dir: join([base.data_dir(), seg]),
        data_local_dir: join([base.data_local_dir(), seg]),
        preference_dir: join([base.preference_dir(), seg]),
        runtime_dir: opt_join(base.runtime_dir(), seg),
        state_dir: opt_join(base.state_dir(), seg),
      })
    }
    None => None
  }
}

///|
pub fn ProjectDirs::project_path(self : ProjectDirs) -> String {
  self.project_path
}

///|
pub fn ProjectDirs::cache_dir(self : ProjectDirs) -> String {
  self.cache_dir
}

///|
pub fn ProjectDirs::config_dir(self : ProjectDirs) -> String {
  self.config_dir
}

///|
pub fn ProjectDirs::config_local_dir(self : ProjectDirs) -> String {
  self.config_local_dir
}

///|
pub fn ProjectDirs::data_dir(self : ProjectDirs) -> String {
  self.data_dir
}

///|
pub fn ProjectDirs::data_local_dir(self : ProjectDirs) -> String {
  self.data_local_dir
}

///|
pub fn ProjectDirs::preference_dir(self : ProjectDirs) -> String {
  self.preference_dir
}

///|
pub fn ProjectDirs::runtime_dir(self : ProjectDirs) -> String? {
  self.runtime_dir
}

///|
pub fn ProjectDirs::state_dir(self : ProjectDirs) -> String? {
  self.state_dir
}
