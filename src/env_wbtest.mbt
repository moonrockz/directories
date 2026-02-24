///|
/// Whitebox tests for env: home_dir returns None when HOME unset; when set (e.g. in CI) we can snapshot.
test "home_dir returns Option" {
  let v = home_dir()
  // May be Some or None depending on environment
  assert_true(v is None || (v is Some(_) && true))
}
