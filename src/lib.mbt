///|
/// # moonrockz/directories
///
/// Platform-specific config, cache, and data directory paths for MoonBit.
/// Port of the [directories-rs](https://codeberg.org/dirs/directories-rs) API.
///
/// **Paths are OS-specific:** Windows uses LOCALAPPDATA/APPDATA and USERPROFILE;
/// Unix uses XDG_* when set, otherwise \$HOME subdirs (.config, .cache, .local/share).
/// Path separators follow the OS (\\\\ on Windows, / on Unix).
///
/// ## Public API
///
/// - **BaseDirs** — User-level cache, config, data, preference, runtime, state dirs.
/// - **UserDirs** — Home plus Desktop, Documents, Downloads, Music, Pictures, etc.
/// - **ProjectDirs** — App-scoped dirs from qualifier/organization/application.
/// - **join(segments)** — Join path segments with the OS separator.
/// - **path_sep()** — Current OS path separator (\"\\\\\" or \"/\").
/// - **platform()** / **is_windows()** / **Platform** — Runtime OS detection.
///
/// ## Example
///
/// \`\`\`
/// match @directories.BaseDirs::new() {
///   Some(base) => base.config_dir()  // e.g. /home/alice/.config or C:\\\\Users\\\\alice\\\\AppData\\\\Roaming
///   None => ()
/// }
/// match @directories.ProjectDirs::from(\"com\", \"Acme\", \"MyApp\") {
///   Some(p) => p.cache_dir()
///   None => ()
/// }
/// \`\`\`
