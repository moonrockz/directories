///|
/// Tests for platform detection. Values depend on the OS where tests run.

///|
test "platform returns a known variant" {
  let p = @directories.platform()
  assert_true(
    p is @directories.Platform::Windows ||
    p is @directories.Platform::Linux ||
    p is @directories.Platform::Darwin ||
    p is @directories.Platform::Unknown,
  )
}

///|
test "is_windows matches platform Windows" {
  let expected = @directories.platform() is @directories.Platform::Windows
  assert_eq(@directories.is_windows(), expected)
}
