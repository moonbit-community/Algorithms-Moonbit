test "get_hash" {
  let hash = @string_hash.StringHash::new("abcd")
  inspect!(hash.get_hash!(right=1), content="133")
  inspect!(hash.get_hash!(left=2, right=2), content="3")
}
