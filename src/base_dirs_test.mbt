///|
test "BaseDirs::new returns Some when HOME set" {
  match @directories.BaseDirs::new() {
    Some(base) => {
      let home = base.home_dir()
      assert_true(home != "")
      assert_true(base.config_dir() != "")
      assert_true(base.cache_dir() != "")
      assert_true(base.data_dir() != "")
      // config_dir should contain home path or .config
      assert_true(
        base.config_dir().contains(".config") ||
        base.config_dir().contains(home),
      )
    }
    None => () // HOME unset in env, skip assertions
  }
}

///|
test "BaseDirs getters return consistent paths" {
  match @directories.BaseDirs::new() {
    Some(base) => {
      // On Unix, config == config_local and preference == config; on Windows they differ (APPDATA vs LOCALAPPDATA).
      if !@directories.is_windows() {
        assert_true(base.config_dir() == base.config_local_dir())
        assert_true(base.preference_dir() == base.config_dir())
      }
      assert_true(base.data_dir() == base.data_local_dir())
    }
    None => ()
  }
}

///|
test "BaseDirs optional dirs are Option" {
  match @directories.BaseDirs::new() {
    Some(base) => {
      let _ = base.executable_dir()
      let _ = base.runtime_dir()
      let _ = base.state_dir()
    }
    None => ()
  }
}
