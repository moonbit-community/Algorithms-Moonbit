///|
test "basic construction and queries" {
  let sam = SuffixAutomaton::new()
  sam.build("ababa")
  assert_eq(true, sam.contains("aba"))
  assert_eq(true, sam.contains("bab"))
  assert_eq(sam.distinct_substring_count(), 9)
}

///|
test "repeated characters collapse correctly" {
  let sam = SuffixAutomaton::new()
  sam.build("aaaa")
  assert_eq(true, sam.contains("a"))
  assert_eq(true, sam.contains("aaaa"))
  assert_eq(true, !sam.contains("aaaaa"))
  assert_eq(sam.distinct_substring_count(), 4)
}

///|
test "incremental extension matches build" {
  let sam_build = SuffixAutomaton::new()
  sam_build.build("banana")
  let sam_extend = SuffixAutomaton::new()
  let text = "banana"
  for i = 0; i < text.length(); i = i + 1 {
    sam_extend.extend(text.code_unit_at(i).to_char().unwrap())
  }
  assert_eq(true, sam_extend.contains("nan"))
  assert_eq(true, sam_extend.contains("banana"))
  assert_eq(sam_build.distinct_substring_count(), 7)
  assert_eq(sam_extend.distinct_substring_count(), 7)
}

///|
test "longest common substring length" {
  let sam = SuffixAutomaton::new()
  sam.build("abracadabra")
  assert_eq(sam.longest_common_substring_length("cadabraa"), 7)
  assert_eq(sam.longest_common_substring_length("xyz"), 0)
  assert_eq(sam.longest_common_substring_length("bravo"), 3)
}

///|
test "clear resets automaton" {
  let sam = SuffixAutomaton::new()
  sam.build("hello")
  assert_eq(true, sam.contains("ell"))
  sam.clear()
  assert_eq(true, !sam.contains("ell"))
  sam.build("world")
  assert_eq(true, sam.contains("orl"))
}

///|
test "alphabet with symbols" {
  let sam = SuffixAutomaton::new()
  sam.build("@#@@!!")
  assert_eq(true, sam.contains("@#"))
  assert_eq(true, sam.contains("!!"))
  assert_eq(sam.distinct_substring_count(), 13)
}
