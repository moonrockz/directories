# directories port – implementation summary

Port of [directories-rs](https://codeberg.org/dirs/directories-rs) to MoonBit (moonrockz/directories).

## Done

- Repo scaffold: moon.mod.json, src/moon.pkg, AGENTS.md, CLAUDE.md, CI (ci.yml, release.yml), mise-tasks (test/unit, release/version, release/credentials, release/publish).
- **Env and path**: Internal `get_env` / `home_dir` via moonbitlang/x/sys; `path_util.join` for path segments.
- **BaseDirs**: `BaseDirs::new() -> Option[BaseDirs]`; getters for home, cache, config, config_local, data, data_local, preference, executable_dir, runtime_dir, state_dir (XDG/Linux-style from env).
- **UserDirs**: `UserDirs::new() -> Option[UserDirs]`; getters for home plus optional audio, desktop, document, download, font, picture, public, template, video (XDG_* or $HOME subdirs).
- **ProjectDirs**: `ProjectDirs::from(qualifier, organization, application) -> Option[ProjectDirs]`; project path by platform (Linux/macOS/Windows heuristic from env); getters for project_path, cache, config, data, preference, runtime_dir, state_dir.
- **lib.mbt**: Package entry; public API is BaseDirs, UserDirs, ProjectDirs, join.
- **Tests**: path_util_test, env_wbtest, base_dirs_test, user_dirs_test, project_dirs_test (10 tests, all pass).
- **Docs**: README.mbt.md with installation and API summary.

## v1 scope

- Paths from environment variables only (HOME, XDG_* on Linux; APPDATA/LOCALAPPDATA for Windows heuristic; /Users/ in HOME for macOS heuristic).
- No directory creation or existence checks.
- No native platform APIs (e.g. Windows Known Folders, macOS NSSearchPath); can be added later.
