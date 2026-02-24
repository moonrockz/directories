///|
/// Tests for platform detection. Values depend on the OS where tests run.

///|
test "platform returns a known variant" {
  let p = platform()
  assert_true(
    p is Platform::Windows ||
    p is Platform::Linux ||
    p is Platform::Darwin ||
    p is Platform::Unknown,
  )
}

///|
test "is_windows matches platform Windows" {
  let expected = platform() is Platform::Windows
  assert_eq(is_windows(), expected)
}
