///|
/// UserDirs: user-facing standard directories (Desktop, Documents, Music, etc.).
/// v1 uses XDG_* env vars or $HOME subdirs.
pub struct UserDirs {
  home_dir : String
  audio_dir : String?
  desktop_dir : String?
  document_dir : String?
  download_dir : String?
  font_dir : String?
  picture_dir : String?
  public_dir : String?
  template_dir : String?
  video_dir : String?
}

///|
fn user_dir_from_env(env_key : String, home_default : String) -> String? {
  match get_env(env_key) {
    Some(p) => if p != "" { Some(p) } else { Some(home_default) }
    None => Some(home_default)
  }
}

///|
/// Create UserDirs from current environment. Returns None if HOME is not set.
pub fn UserDirs::new() -> UserDirs? {
  match home_dir() {
    Some(home) =>
      Some(UserDirs::{
        home_dir: home,
        audio_dir: user_dir_from_env("XDG_MUSIC_DIR", join([home, "Music"])),
        desktop_dir: user_dir_from_env(
          "XDG_DESKTOP_DIR",
          join([home, "Desktop"]),
        ),
        document_dir: user_dir_from_env(
          "XDG_DOCUMENTS_DIR",
          join([home, "Documents"]),
        ),
        download_dir: user_dir_from_env(
          "XDG_DOWNLOAD_DIR",
          join([home, "Downloads"]),
        ),
        font_dir: Some(join([home, ".local", "share", "fonts"])),
        picture_dir: user_dir_from_env(
          "XDG_PICTURES_DIR",
          join([home, "Pictures"]),
        ),
        public_dir: user_dir_from_env(
          "XDG_PUBLICSHARE_DIR",
          join([home, "Public"]),
        ),
        template_dir: user_dir_from_env(
          "XDG_TEMPLATES_DIR",
          join([home, "Templates"]),
        ),
        video_dir: user_dir_from_env("XDG_VIDEOS_DIR", join([home, "Videos"])),
      })
    None => None
  }
}

///|
pub fn UserDirs::home_dir(self : UserDirs) -> String {
  self.home_dir
}

///|
pub fn UserDirs::audio_dir(self : UserDirs) -> String? {
  self.audio_dir
}

///|
pub fn UserDirs::desktop_dir(self : UserDirs) -> String? {
  self.desktop_dir
}

///|
pub fn UserDirs::document_dir(self : UserDirs) -> String? {
  self.document_dir
}

///|
pub fn UserDirs::download_dir(self : UserDirs) -> String? {
  self.download_dir
}

///|
pub fn UserDirs::font_dir(self : UserDirs) -> String? {
  self.font_dir
}

///|
pub fn UserDirs::picture_dir(self : UserDirs) -> String? {
  self.picture_dir
}

///|
pub fn UserDirs::public_dir(self : UserDirs) -> String? {
  self.public_dir
}

///|
pub fn UserDirs::template_dir(self : UserDirs) -> String? {
  self.template_dir
}

///|
pub fn UserDirs::video_dir(self : UserDirs) -> String? {
  self.video_dir
}
