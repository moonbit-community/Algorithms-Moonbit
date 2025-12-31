///|
test "persistent trie versions" {
  let trie0 : PersistentTrie[Char, Int] = PersistentTrie::new()
  let cat = ['c', 'a', 't']
  let trie1 = trie0.insert(cat.copy(), 1)
  assert_eq(trie0.get(cat.copy()), None)
  assert_eq(trie1.get(cat.copy()), Some(1))
  let car = ['c', 'a', 'r']
  let trie2 = trie1.insert(car.copy(), 2)
  assert_eq(trie1.get(car.copy()), None)
  assert_eq(trie2.get(car.copy()), Some(2))
  assert_eq(trie2.get(cat.copy()), Some(1))
  let trie3 = trie2.insert(cat.copy(), 10)
  assert_eq(trie2.get(cat.copy()), Some(1))
  assert_eq(trie3.get(cat.copy()), Some(10))
}

///|
test "persistent trie empty key and clear" {
  let trie0 : PersistentTrie[Char, Int] = PersistentTrie::new()
  let empty : Array[Char] = Array::new()
  let trie1 = trie0.insert(empty.copy(), 42)
  assert_eq(trie0.get(empty.copy()), None)
  assert_eq(trie1.get(empty.copy()), Some(42))
  assert_eq(trie1.is_empty(), false)
  let trie2 = trie1.clear()
  assert_eq(trie2.get(empty.copy()), None)
  assert_eq(trie2.is_empty(), true)
}

///|
test "persistent trie with integer keys" {
  let trie0 : PersistentTrie[Int, Int] = PersistentTrie::new()
  let first = [1, 2, 3]
  let second = [1, 2, 4]
  let trie1 = trie0.insert(first.copy(), 7)
  let trie2 = trie1.insert(second.copy(), 9)
  assert_eq(trie0.get(first.copy()), None)
  assert_eq(trie1.get(first.copy()), Some(7))
  assert_eq(trie1.get(second.copy()), None)
  assert_eq(trie2.get(first.copy()), Some(7))
  assert_eq(trie2.get(second.copy()), Some(9))
}
