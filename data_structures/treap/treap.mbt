///|
struct Node[K, V] {
  key : K
  mut value : V
  priority : Int
  mut left : Node[K, V]?
  mut right : Node[K, V]?
}

///|
fn[K, V] Node::new(key : K, value : V, priority : Int) -> Node[K, V] {
  Node::{ key, value, priority, left: None, right: None }
}

///|
fn[K : Compare, V] split(
  node_opt : Node[K, V]?,
  key : K,
) -> (Node[K, V]?, Node[K, V]?) {
  match node_opt {
    None => (None, None)
    Some(node_value) => {
      let node = node_value
      if key.compare(node.key) < 0 {
        let (less, greater) = split(node.left, key)
        node.left = greater
        (less, Some(node))
      } else {
        let (less, greater) = split(node.right, key)
        node.right = less
        (Some(node), greater)
      }
    }
  }
}

///|
fn[K, V] merge(left_opt : Node[K, V]?, right_opt : Node[K, V]?) -> Node[K, V]? {
  match (left_opt, right_opt) {
    (None, right_side) => right_side
    (left_side, None) => left_side
    (Some(left_value), Some(right_value)) => {
      let left = left_value
      let right = right_value
      if left.priority > right.priority {
        let merged = merge(left.right, Some(right))
        left.right = merged
        Some(left)
      } else {
        let merged = merge(Some(left), right.left)
        right.left = merged
        Some(right)
      }
    }
  }
}

///|
fn[K : Compare, V] insert_node(
  node_opt : Node[K, V]?,
  key : K,
  value : V,
  priority : Int,
) -> (Node[K, V]?, Bool) {
  match node_opt {
    None => (Some(Node::new(key, value, priority)), true)
    Some(node_value) => {
      let node = node_value
      let cmp = key.compare(node.key)
      if cmp == 0 {
        node.value = value
        (Some(node), false)
      } else if priority > node.priority {
        let (less, greater) = split(Some(node), key)
        let new_node = Node::new(key, value, priority)
        new_node.left = less
        new_node.right = greater
        (Some(new_node), true)
      } else if cmp < 0 {
        let (new_left, inserted) = insert_node(node.left, key, value, priority)
        node.left = new_left
        (Some(node), inserted)
      } else {
        let (new_right, inserted) = insert_node(
          node.right,
          key,
          value,
          priority,
        )
        node.right = new_right
        (Some(node), inserted)
      }
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
        let merged = merge(node.left, node.right)
        (merged, true)
      } else if cmp < 0 {
        let (new_left, removed) = remove_node(node.left, key)
        node.left = new_left
        (Some(node), removed)
      } else {
        let (new_right, removed) = remove_node(node.right, key)
        node.right = new_right
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
pub struct Treap[K, V] {
  mut root : Node[K, V]?
  mut size : Int
  mut rng_state : Int
}

///|
pub fn[K, V] Treap::new() -> Treap[K, V] {
  Treap::{ root: None, size: 0, rng_state: 123_456_789 }
}

///|
pub fn[K, V] len(self : Treap[K, V]) -> Int {
  self.size
}

///|
pub fn[K, V] is_empty(self : Treap[K, V]) -> Bool {
  self.size == 0
}

///|
pub fn[K, V] clear(self : Treap[K, V]) -> Unit {
  self.root = None
  self.size = 0
}

///|
fn[K, V] Treap::next_priority(self : Treap[K, V]) -> Int {
  let modulus = 2_147_483_647
  let mut state = (self.rng_state * 1_103_515_245 + 12_345) % modulus
  if state < 0 {
    state = -state
  }
  if state == 0 {
    state = 1
  }
  self.rng_state = state
  state
}

///|
pub fn[K : Compare, V] Treap::insert(
  self : Treap[K, V],
  key : K,
  value : V,
) -> Unit {
  let priority = self.next_priority()
  let (new_root, inserted) = insert_node(self.root, key, value, priority)
  self.root = new_root
  if inserted {
    self.size = self.size + 1
  }
}

///|
pub fn[K : Compare, V] Treap::get(self : Treap[K, V], key : K) -> V? {
  find_node(self.root, key)
}

///|
pub fn[K : Compare, V] Treap::contains(self : Treap[K, V], key : K) -> Bool {
  match self.get(key) {
    Some(_) => true
    None => false
  }
}

///|
pub fn[K : Compare, V] Treap::remove(self : Treap[K, V], key : K) -> Bool {
  let (new_root, removed) = remove_node(self.root, key)
  self.root = new_root
  if removed {
    self.size = self.size - 1
  }
  removed
}

///|
pub impl[K, V] Default for Treap[K, V] with default() {
  Treap::new()
}
