test {
    inspect!(@manacher.manacher("abba".to_string()), content="4")
    inspect!(@manacher.manacher("abacaba".to_string()), content="7")
}