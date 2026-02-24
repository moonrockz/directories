///|
test "ProjectDirs::from returns Some when HOME set" {
  match @directories.ProjectDirs::from("com", "Foo Corp", "Bar App") {
    Some(p) => {
      assert_true(p.project_path() != "")
      assert_true(p.config_dir() != "")
      assert_true(p.cache_dir() != "")
    }
    None => ()
  }
}
