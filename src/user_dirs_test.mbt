///|
test "UserDirs::new returns Some when HOME set" {
  match @directories.UserDirs::new() {
    Some(u) => {
      assert_true(u.home_dir() != "")
      assert_true(u.desktop_dir() is Some(_))
    }
    None => ()
  }
}
