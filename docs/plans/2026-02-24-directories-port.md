# directories port – implementation summary

Port of [directories-rs](https://codeberg.org/dirs/directories-rs) to MoonBit (moonrockz/directories).

## Done

- Repo scaffold: moon.mod.json, src/moon.pkg, AGENTS.md, CLAUDE.md, CI (ci.yml, release.yml), mise-tasks (test/unit, release/version, release/credentials, release/publish).
- **Env and path**: Internal `get_env` / `home_dir` (USERPROFILE on Windows, else HOME); `path_util.join` and `path_sep()` use OS separator (\\ on Windows, / on Unix).
- **BaseDirs**: `BaseDirs::new() -> Option[BaseDirs]`; OS-specific: Windows LOCALAPPDATA/APPDATA; Unix XDG_* or $HOME/.config, .cache, .local/share. Getters for home, cache, config, etc.
- **UserDirs**: `UserDirs::new() -> Option[UserDirs]`; getters for home plus optional audio, desktop, document, download, font, picture, public, template, video (XDG_* or $HOME subdirs).
- **ProjectDirs**: `ProjectDirs::from(qualifier, organization, application) -> Option[ProjectDirs]`; project path from runtime `platform()` (Windows/Darwin/Linux segment rules); getters for project_path, cache, config, data, etc.
- **lib.mbt**: Package entry; public API is BaseDirs, UserDirs, ProjectDirs, join.
- **Tests**: path_util_test, env_wbtest, base_dirs_test, user_dirs_test, project_dirs_test (10 tests, all pass).
- **Docs**: README.mbt.md with installation and API summary.

## v1 scope

- Paths from environment variables only (HOME, XDG_* on Linux; APPDATA/LOCALAPPDATA for Windows heuristic; /Users/ in HOME for macOS heuristic).
- No directory creation or existence checks.
- No native platform APIs (e.g. Windows Known Folders, macOS NSSearchPath); can be added later.
