# Trie (Mutable)

A generic mutable trie (prefix tree) implemented in [MoonBit](https://www.moonbitlang.com/). The data structure stores values
for sequences of keys, growing nodes lazily as new prefixes are inserted. The implementation follows the same API style used by
other data structures in this repository while mirroring the ergonomics of the [Rust version](https://github.com/TheAlgorithms/Rust/blob/master/src/data_structures/trie.rs).

---

## ✨ Features
- **Generic over key and value types** as long as keys implement `Eq`
- **Prefix sharing**: nodes are created only when necessary during insertion
- **Safe overwrites**: inserting the same key replaces the stored value
- **Utility helpers** for membership checks, clearing the trie, and `Default` construction

---

## 🧩 API Overview

```moonbit
pub struct Trie[K, V] {
  mut root : TrieNode[K, V]
}

pub fn[K, V] Trie::new() -> Trie[K, V]

pub fn[K : Eq, V] Trie::insert(self : Trie[K, V], key : Array[K], value : V) -> Unit

pub fn[K : Eq, V] Trie::get(self : Trie[K, V], key : Array[K]) -> V?

pub fn[K : Eq, V] Trie::contains(self : Trie[K, V], key : Array[K]) -> Bool

pub fn[K, V] Trie::clear(self : Trie[K, V]) -> Unit

pub fn[K, V] Trie::is_empty(self : Trie[K, V]) -> Bool

pub impl[K, V] Default for Trie[K, V] with default() -> Trie[K, V]

