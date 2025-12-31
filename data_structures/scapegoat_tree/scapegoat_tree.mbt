///|
struct Node[K, V] {
  key : K
  mut value : V
  mut size : Int
  mut left : Node[K, V]?
  mut right : Node[K, V]?
}

///|
fn[K, V] Node::new(key : K, value : V) -> Node[K, V] {
  Node::{ key, value, size: 1, left: None, right: None }
}

///|
priv struct Entry[K, V] {
  key : K
  value : V
}

///|
fn[K, V] node_size(node_opt : Node[K, V]?) -> Int {
  match node_opt {
    None => 0
    Some(node) => node.size
  }
}

///|
fn[K, V] is_balanced(node : Node[K, V]) -> Bool {
  let left_size = node_size(node.left)
  let right_size = node_size(node.right)
  left_size * 3 <= node.size * 2 && right_size * 3 <= node.size * 2
}

///|
fn[K, V] collect_entries(
  node_opt : Node[K, V]?,
  entries : Array[Entry[K, V]],
) -> Unit {
  match node_opt {
    None => ()
    Some(node_value) => {
      let node = node_value
      let left_subtree = node.left
      let right_subtree = node.right
      collect_entries(left_subtree, entries)
      entries.push(Entry::{ key: node.key, value: node.value })
      collect_entries(right_subtree, entries)
    }
  }
}

///|
fn[K, V] build_balanced(
  entries : Array[Entry[K, V]],
  start : Int,
  end : Int,
) -> Node[K, V]? {
  if start >= end {
    None
  } else {
    let mid = (start + end) / 2
    let entry = entries[mid]
    let node = Node::new(entry.key, entry.value)
    node.left = build_balanced(entries, start, mid)
    node.right = build_balanced(entries, mid + 1, end)
    node.size = node_size(node.left) + node_size(node.right) + 1
    Some(node)
  }
}

///|
fn[K, V] rebuild(node_opt : Node[K, V]?) -> Node[K, V]? {
  match node_opt {
    None => None
    Some(node) => {
      let entries : Array[Entry[K, V]] = []
      collect_entries(Some(node), entries)
      build_balanced(entries, 0, entries.length())
    }
  }
}

///|
fn[K : Compare, V] insert_node(
  node_opt : Node[K, V]?,
  key : K,
  value : V,
) -> (Node[K, V]?, Bool, Bool) {
  match node_opt {
    None => (Some(Node::new(key, value)), true, false)
    Some(node_value) => {
      let node = node_value
      let cmp = key.compare(node.key)
      if cmp == 0 {
        node.value = value
        (Some(node), false, false)
      } else if cmp < 0 {
        let (new_left, inserted, rebalanced) = insert_node(
          node.left,
          key,
          value,
        )
        node.left = new_left
        if inserted {
          node.size = node_size(node.left) + node_size(node.right) + 1
        }
        if inserted && !rebalanced && !is_balanced(node) {
          (rebuild(Some(node)), true, true)
        } else {
          (Some(node), inserted, rebalanced)
        }
      } else {
        let (new_right, inserted, rebalanced) = insert_node(
          node.right,
          key,
          value,
        )
        node.right = new_right
        if inserted {
          node.size = node_size(node.left) + node_size(node.right) + 1
        }
        if inserted && !rebalanced && !is_balanced(node) {
          (rebuild(Some(node)), true, true)
        } else {
          (Some(node), inserted, rebalanced)
        }
      }
    }
  }
}

///|
fn[K, V] remove_min(node : Node[K, V]) -> (Node[K, V], Node[K, V]?) {
  match node.left {
    None => {
      let right_subtree = node.right
      (node, right_subtree)
    }
    Some(left_node) => {
      let (min_node, new_left) = remove_min(left_node)
      node.left = new_left
      node.size = node_size(node.left) + node_size(node.right) + 1
      (min_node, Some(node))
    }
  }
}

///|
fn[K : Compare, V] remove_node(
  node_opt : Node[K, V]?,
  key : K,
) -> (Node[K, V]?, Bool) {
  match node_opt {
    None => (None, false)
    Some(node_value) => {
      let node = node_value
      let cmp = key.compare(node.key)
      if cmp == 0 {
        match (node.left, node.right) {
          (None, None) => (None, true)
          (Some(left_node), None) => (Some(left_node), true)
          (None, Some(right_node)) => (Some(right_node), true)
          (Some(left_node), Some(right_node)) => {
            let (min_node, new_right) = remove_min(right_node)
            min_node.left = Some(left_node)
            min_node.right = new_right
            min_node.size = node_size(min_node.left) +
              node_size(min_node.right) +
              1
            (Some(min_node), true)
          }
        }
      } else if cmp < 0 {
        let (new_left, removed) = remove_node(node.left, key)
        node.left = new_left
        if removed {
          node.size = node_size(node.left) + node_size(node.right) + 1
        }
        (Some(node), removed)
      } else {
        let (new_right, removed) = remove_node(node.right, key)
        node.right = new_right
        if removed {
          node.size = node_size(node.left) + node_size(node.right) + 1
        }
        (Some(node), removed)
      }
    }
  }
}

///|
fn[K : Compare, V] find_node(node_opt : Node[K, V]?, key : K) -> V? {
  match node_opt {
    None => None
    Some(node_value) => {
      let node = node_value
      let cmp = key.compare(node.key)
      if cmp == 0 {
        Some(node.value)
      } else if cmp < 0 {
        find_node(node.left, key)
      } else {
        find_node(node.right, key)
      }
    }
  }
}

///|
pub struct ScapegoatTree[K, V] {
  mut root : Node[K, V]?
  mut size : Int
  mut max_size : Int
}

///|
pub fn[K, V] ScapegoatTree::new() -> ScapegoatTree[K, V] {
  ScapegoatTree::{ root: None, size: 0, max_size: 0 }
}

///|
pub fn[K, V] ScapegoatTree::len(self : ScapegoatTree[K, V]) -> Int {
  self.size
}

///|
pub fn[K, V] ScapegoatTree::is_empty(self : ScapegoatTree[K, V]) -> Bool {
  self.size == 0
}

///|
pub fn[K, V] ScapegoatTree::clear(self : ScapegoatTree[K, V]) -> Unit {
  self.root = None
  self.size = 0
  self.max_size = 0
}

///|
pub fn[K : Compare, V] ScapegoatTree::insert(
  self : ScapegoatTree[K, V],
  key : K,
  value : V,
) -> Unit {
  let (new_root, inserted, _) = insert_node(self.root, key, value)
  self.root = new_root
  if inserted {
    self.size = self.size + 1
    if self.size > self.max_size {
      self.max_size = self.size
    }
  }
}

///|
pub fn[K : Compare, V] ScapegoatTree::get(
  self : ScapegoatTree[K, V],
  key : K,
) -> V? {
  find_node(self.root, key)
}

///|
pub fn[K : Compare, V] ScapegoatTree::contains(
  self : ScapegoatTree[K, V],
  key : K,
) -> Bool {
  match self.get(key) {
    Some(_) => true
    None => false
  }
}

///|
pub fn[K : Compare, V] ScapegoatTree::remove(
  self : ScapegoatTree[K, V],
  key : K,
) -> Bool {
  let (new_root, removed) = remove_node(self.root, key)
  self.root = new_root
  if removed {
    self.size = self.size - 1
    if self.size == 0 {
      self.root = None
      self.max_size = 0
    } else if self.size * 3 < self.max_size * 2 {
      self.root = rebuild(self.root)
      self.max_size = self.size
    }
  }
  removed
}

///|
pub impl[K, V] Default for ScapegoatTree[K, V] with default() {
  ScapegoatTree::new()
}
