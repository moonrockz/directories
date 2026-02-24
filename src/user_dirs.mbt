///|
/// User-facing directories: home, Desktop, Documents, Downloads, Music, Pictures, etc.
/// On **Unix:** XDG_* when set (e.g. XDG_DOCUMENTS_DIR), else \$HOME/Desktop, \$HOME/Documents, etc.
/// On **Windows:** USERPROFILE plus Desktop, Documents, Downloads, Music, Pictures, etc.
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
fn user_dirs_unix(home : String) -> UserDirs {
  UserDirs::{
    home_dir: home,
    audio_dir: user_dir_from_env("XDG_MUSIC_DIR", join([home, "Music"])),
    desktop_dir: user_dir_from_env("XDG_DESKTOP_DIR", join([home, "Desktop"])),
    document_dir: user_dir_from_env(
      "XDG_DOCUMENTS_DIR",
      join([home, "Documents"]),
    ),
    download_dir: user_dir_from_env(
      "XDG_DOWNLOAD_DIR",
      join([home, "Downloads"]),
    ),
    font_dir: Some(join([home, ".local", "share", "fonts"])),
    picture_dir: user_dir_from_env("XDG_PICTURES_DIR", join([home, "Pictures"])),
    public_dir: user_dir_from_env("XDG_PUBLICSHARE_DIR", join([home, "Public"])),
    template_dir: user_dir_from_env(
      "XDG_TEMPLATES_DIR",
      join([home, "Templates"]),
    ),
    video_dir: user_dir_from_env("XDG_VIDEOS_DIR", join([home, "Videos"])),
  }
}

///|
fn user_dirs_windows(home : String) -> UserDirs {
  UserDirs::{
    home_dir: home,
    audio_dir: Some(join([home, "Music"])),
    desktop_dir: Some(join([home, "Desktop"])),
    document_dir: Some(join([home, "Documents"])),
    download_dir: Some(join([home, "Downloads"])),
    font_dir: None,
    picture_dir: Some(join([home, "Pictures"])),
    public_dir: Some(join([home, "Public"])),
    template_dir: Some(join([home, "Templates"])),
    video_dir: Some(join([home, "Videos"])),
  }
}

///|
/// Creates UserDirs from the current environment. Returns `None` if home is not set.
///
/// Example:
///   match UserDirs::new() {
///     Some(u) => u.download_dir()  // e.g. /home/alice/Downloads or C:\Users\alice\Downloads
///     None => ...
///   }
pub fn UserDirs::new() -> UserDirs? {
  match home_dir() {
    Some(home) =>
      Some(
        if is_windows() {
          user_dirs_windows(home)
        } else {
          user_dirs_unix(home)
        },
      )
    None => None
  }
}

///| User home directory.
pub fn UserDirs::home_dir(self : UserDirs) -> String {
  self.home_dir
}

///| Music/Audio directory (e.g. Music on Windows, XDG_MUSIC_DIR or Music on Unix).
pub fn UserDirs::audio_dir(self : UserDirs) -> String? {
  self.audio_dir
}

///| Desktop directory.
pub fn UserDirs::desktop_dir(self : UserDirs) -> String? {
  self.desktop_dir
}

///| Documents directory.
pub fn UserDirs::document_dir(self : UserDirs) -> String? {
  self.document_dir
}

///| Downloads directory.
pub fn UserDirs::download_dir(self : UserDirs) -> String? {
  self.download_dir
}

///| Fonts directory (Unix: .local/share/fonts); None on Windows.
pub fn UserDirs::font_dir(self : UserDirs) -> String? {
  self.font_dir
}

///| Pictures directory.
pub fn UserDirs::picture_dir(self : UserDirs) -> String? {
  self.picture_dir
}

///| Public share directory.
pub fn UserDirs::public_dir(self : UserDirs) -> String? {
  self.public_dir
}

///| Templates directory.
pub fn UserDirs::template_dir(self : UserDirs) -> String? {
  self.template_dir
}

///| Videos directory.
pub fn UserDirs::video_dir(self : UserDirs) -> String? {
  self.video_dir
}
