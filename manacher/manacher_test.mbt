test {
  inspect(manacher("abba".to_string()), content="4")
  inspect(manacher("abacaba".to_string()), content="7")
}
