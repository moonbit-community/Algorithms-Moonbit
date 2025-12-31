///|
/// A node inside the persistent trie. Each node stores an optional value and
/// references children by key segments.
struct TrieNode[K, V] {
  keys : Array[K]
  children : Array[TrieNode[K, V]]
  value : V?
}

///|
fn[K, V] TrieNode::new() -> TrieNode[K, V] {
  TrieNode::{ keys: Array::new(), children: Array::new(), value: None }
}

///|
fn[T] clone_array(source : Array[T]) -> Array[T] {
  let result = Array::new()
  for idx in 0..<source.length() {
    result.push(source[idx])
  }
  result
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
) -> TrieNode[K, V] {
  if depth == key.length() {
    return TrieNode::{
      keys: self.keys,
      children: self.children,
      value: Some(value),
    }
  }
  let current = key[depth]
  match self.find_child_index(current) {
    Some(idx) => {
      let child = self.children[idx]
      let new_child = child.insert_at(key, depth + 1, value)
      let new_children = clone_array(self.children)
      new_children[idx] = new_child
      TrieNode::{ keys: self.keys, children: new_children, value: self.value }
    }
    None => {
      let new_keys = clone_array(self.keys)
      new_keys.push(current)
      let new_children = clone_array(self.children)
      let child = TrieNode::new().insert_at(key, depth + 1, value)
      new_children.push(child)
      TrieNode::{ keys: new_keys, children: new_children, value: self.value }
    }
  }
}

///|
fn[K : Eq, V] TrieNode::get_at(
  self : TrieNode[K, V],
  key : Array[K],
  depth : Int,
) -> V? {
  if depth == key.length() {
    return self.value
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
fn[K, V : Eq] TrieNode::is_empty(self : TrieNode[K, V]) -> Bool {
  self.value == None && self.children.length() == 0
}

///|
/// A persistent trie that stores values associated with key sequences.
/// Each insertion returns a new trie instance while preserving previous ones.
pub struct PersistentTrie[K, V] {
  root : TrieNode[K, V]
}

///|
pub fn[K, V] PersistentTrie::new() -> PersistentTrie[K, V] {
  PersistentTrie::{ root: TrieNode::new() }
}

///|
/// Inserts a value associated with the provided key sequence.
///
/// If the key already exists, its value is overwritten in the new version.
pub fn[K : Eq, V] PersistentTrie::insert(
  self : PersistentTrie[K, V],
  key : Array[K],
  value : V,
) -> PersistentTrie[K, V] {
  let root = self.root.insert_at(key, 0, value)
  PersistentTrie::{ root, }
}

///|
/// Retrieves the value stored for the exact key sequence.
///
/// Returns `None` if the key has not been inserted.
pub fn[K : Eq, V] PersistentTrie::get(
  self : PersistentTrie[K, V],
  key : Array[K],
) -> V? {
  self.root.get_at(key, 0)
}

///|
/// Checks whether the trie contains the given key sequence.
pub fn[K : Eq, V] PersistentTrie::contains(
  self : PersistentTrie[K, V],
  key : Array[K],
) -> Bool {
  match self.get(key) {
    Some(_) => true
    None => false
  }
}

///|
/// Creates a new empty trie, leaving the current version untouched.
pub fn[K, V] PersistentTrie::clear(
  self : PersistentTrie[K, V],
) -> PersistentTrie[K, V] {
  let _ = self
  PersistentTrie::new()
}

///|
/// Checks if the trie holds no key-value pairs.
pub fn[K, V : Eq] PersistentTrie::is_empty(self : PersistentTrie[K, V]) -> Bool {
  self.root.is_empty()
}

///|
pub impl[K, V] Default for PersistentTrie[K, V] with default() {
  PersistentTrie::new()
}
