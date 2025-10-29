///|
test "get_hash" {
  let hash = StringHash::new("abcd")
  inspect(hash.get_hash(right_idx=1), content="133")
  inspect(hash.get_hash(left_idx=2, right_idx=2), content="3")
}
