///|
test "path_util join empty" {
  inspect(@directories.join([]), content="")
}

///|
test "path_util join single" {
  inspect(@directories.join(["home"]), content="home")
}

///|
test "path_util join two" {
  let sep = @directories.path_sep()
  assert_eq(@directories.join(["home", "alice"]), "home" + sep + "alice")
}

///|
test "path_util join skips empty" {
  let sep = @directories.path_sep()
  assert_eq(
    @directories.join(["home", "", "alice", ".config"]),
    "home" + sep + "alice" + sep + ".config",
  )
}
