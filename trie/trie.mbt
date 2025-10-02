///|
/// A node inside the trie. Each node can store an optional value and lazily
/// creates children as new key segments are inserted.
struct TrieNode[K, V] {
  keys : Array[K]
  children : Array[TrieNode[K, V]]
  mut value : V?
}

///|
fn[K, V] TrieNode::new() -> TrieNode[K, V] {
  TrieNode::{ keys: Array::new(), children: Array::new(), value: None }
}

///|
fn[K : Eq, V] TrieNode::find_child_index(
  self : TrieNode[K, V],
  key : K,
) -> Int? {
  for idx in 0..<self.keys.length() {
    if self.keys[idx] == key {
      return Some(idx)
    }
  }
  None
}

///|
fn[K : Eq, V] TrieNode::insert_at(
  self : TrieNode[K, V],
  key : Array[K],
  depth : Int,
  value : V,
) -> Unit {
  if depth == key.length() {
    self.value = Some(value)
    return
  }
  let current = key[depth]
  let child_index = match self.find_child_index(current) {
    Some(idx) => idx
    None => {
      self.keys.push(current)
      self.children.push(TrieNode::new())
      self.children.length() - 1
    }
  }
  let child = self.children[child_index]
  child.insert_at(key, depth + 1, value)
  self.children[child_index] = child
}

///|
fn[K : Eq, V] TrieNode::get_at(
  self : TrieNode[K, V],
  key : Array[K],
  depth : Int,
) -> V? {
  if depth == key.length() {
    return match self.value {
      Some(v) => Some(v)
      None => None
    }
  }
  match self.find_child_index(key[depth]) {
    Some(idx) => {
      let child = self.children[idx]
      child.get_at(key, depth + 1)
    }
    None => None
  }
}

///|
fn[K, V] TrieNode::clear(self : TrieNode[K, V]) -> Unit {
  self.keys.clear()
  self.children.clear()
  self.value = None
}

///|
fn[K, V : Eq] TrieNode::is_empty(self : TrieNode[K, V]) -> Bool {
  self.value == None && self.children.length() == 0
}

///|
/// A mutable trie that stores values associated with key sequences.
pub struct Trie[K, V] {
  root : TrieNode[K, V]
}

///|
pub fn[K, V] Trie::new() -> Trie[K, V] {
  Trie::{ root: TrieNode::new() }
}

///|
/// Inserts a value associated with the provided key sequence.
///
/// If the key already exists, its value is overwritten.
pub fn[K : Eq, V] Trie::insert(
  self : Trie[K, V],
  key : Array[K],
  value : V,
) -> Unit {
  self.root.insert_at(key, 0, value)
}

///|
/// Retrieves the value stored for the exact key sequence.
///
/// Returns `None` if the key has not been inserted.
pub fn[K : Eq, V] Trie::get(self : Trie[K, V], key : Array[K]) -> V? {
  self.root.get_at(key, 0)
}

///|
/// Checks whether the trie contains the given key sequence.
pub fn[K : Eq, V] Trie::contains(self : Trie[K, V], key : Array[K]) -> Bool {
  match self.get(key) {
    Some(_) => true
    None => false
  }
}

///|
/// Removes all keys and values stored in the trie.
pub fn[K, V] Trie::clear(self : Trie[K, V]) -> Unit {
  self.root.clear()
}

///|
/// Checks if the trie holds no key-value pairs.
pub fn[K, V : Eq] Trie::is_empty(self : Trie[K, V]) -> Bool {
  self.root.is_empty()
}

///|
pub impl[K, V] Default for Trie[K, V] with default() {
  Trie::new()
}
