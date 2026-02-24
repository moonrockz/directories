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
  inspect(@directories.join(["home", "alice"]), content="home/alice")
}

///|
test "path_util join skips empty" {
  inspect(
    @directories.join(["home", "", "alice", ".config"]),
    content="home/alice/.config",
  )
}
