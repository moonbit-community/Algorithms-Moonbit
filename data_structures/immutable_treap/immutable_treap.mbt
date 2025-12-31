///|
struct Node[K, V] {
  key : K
  value : V
  priority : Int
  left : Node[K, V]?
  right : Node[K, V]?
}

///|
fn[K, V] Node::new(
  key : K,
  value : V,
  priority : Int,
  left : Node[K, V]?,
  right : Node[K, V]?,
) -> Node[K, V] {
  Node::{ key, value, priority, left, right }
}

///|
fn[K, V] merge(left_opt : Node[K, V]?, right_opt : Node[K, V]?) -> Node[K, V]? {
  match (left_opt, right_opt) {
    (None, right_side) => right_side
    (left_side, None) => left_side
    (Some(left), Some(right)) =>
      if left.priority > right.priority {
        let merged = merge(left.right, Some(right))
        Some(Node::new(left.key, left.value, left.priority, left.left, merged))
      } else {
        let merged = merge(Some(left), right.left)
        Some(
          Node::new(right.key, right.value, right.priority, merged, right.right),
        )
      }
  }
}

///|
fn[K : Compare, V] find_node(node_opt : Node[K, V]?, key : K) -> V? {
  match node_opt {
    None => None
    Some(node) => {
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
fn[K : Compare, V] insert_node(
  node_opt : Node[K, V]?,
  key : K,
  value : V,
  priority : Int,
) -> (Node[K, V]?, Bool) {
  match node_opt {
    None => (Some(Node::new(key, value, priority, None, None)), true)
    Some(node) => {
      let cmp = key.compare(node.key)
      if cmp == 0 {
        (
          Some(Node::new(node.key, value, node.priority, node.left, node.right)),
          false,
        )
      } else if cmp < 0 {
        let (new_left, inserted) = insert_node(node.left, key, value, priority)
        let base = Node::new(
          node.key,
          node.value,
          node.priority,
          new_left,
          node.right,
        )
        match new_left {
          None => (Some(base), inserted)
          Some(left_node) =>
            if left_node.priority > base.priority {
              let rotated = Node::new(
                base.key,
                base.value,
                base.priority,
                left_node.right,
                base.right,
              )
              (
                Some(
                  Node::new(
                    left_node.key,
                    left_node.value,
                    left_node.priority,
                    left_node.left,
                    Some(rotated),
                  ),
                ),
                inserted,
              )
            } else {
              (Some(base), inserted)
            }
        }
      } else {
        let (new_right, inserted) = insert_node(
          node.right,
          key,
          value,
          priority,
        )
        let base = Node::new(
          node.key,
          node.value,
          node.priority,
          node.left,
          new_right,
        )
        match new_right {
          None => (Some(base), inserted)
          Some(right_node) =>
            if right_node.priority > base.priority {
              let rotated = Node::new(
                base.key,
                base.value,
                base.priority,
                base.left,
                right_node.left,
              )
              (
                Some(
                  Node::new(
                    right_node.key,
                    right_node.value,
                    right_node.priority,
                    Some(rotated),
                    right_node.right,
                  ),
                ),
                inserted,
              )
            } else {
              (Some(base), inserted)
            }
        }
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
    Some(node) => {
      let cmp = key.compare(node.key)
      if cmp == 0 {
        (merge(node.left, node.right), true)
      } else if cmp < 0 {
        let (new_left, removed) = remove_node(node.left, key)
        (
          Some(
            Node::new(node.key, node.value, node.priority, new_left, node.right),
          ),
          removed,
        )
      } else {
        let (new_right, removed) = remove_node(node.right, key)
        (
          Some(
            Node::new(node.key, node.value, node.priority, node.left, new_right),
          ),
          removed,
        )
      }
    }
  }
}

///|
pub struct PersistentTreap[K, V] {
  root : Node[K, V]?
  size : Int
  rng_state : Int
}

///|
pub fn[K, V] PersistentTreap::new() -> PersistentTreap[K, V] {
  PersistentTreap::{ root: None, size: 0, rng_state: 123_456_789 }
}

///|
pub fn[K, V] PersistentTreap::len(self : PersistentTreap[K, V]) -> Int {
  self.size
}

///|
pub fn[K, V] PersistentTreap::is_empty(self : PersistentTreap[K, V]) -> Bool {
  self.size == 0
}

///|
pub fn[K, V] PersistentTreap::clear(
  self : PersistentTreap[K, V],
) -> PersistentTreap[K, V] {
  PersistentTreap::{ root: None, size: 0, rng_state: self.rng_state }
}

///|
fn next_priority(state : Int) -> (Int, Int) {
  let modulus = 2_147_483_647
  let mut next_state = (state * 1_103_515_245 + 12_345) % modulus
  if next_state < 0 {
    next_state = -next_state
  }
  if next_state == 0 {
    next_state = 1
  }
  (next_state, next_state)
}

///|
pub fn[K : Compare, V] PersistentTreap::insert(
  self : PersistentTreap[K, V],
  key : K,
  value : V,
) -> PersistentTreap[K, V] {
  let (priority, next_state) = next_priority(self.rng_state)
  let (new_root, inserted) = insert_node(self.root, key, value, priority)
  let size = if inserted { self.size + 1 } else { self.size }
  PersistentTreap::{ root: new_root, size, rng_state: next_state }
}

///|
pub fn[K : Compare, V] PersistentTreap::get(
  self : PersistentTreap[K, V],
  key : K,
) -> V? {
  find_node(self.root, key)
}

///|
pub fn[K : Compare, V] PersistentTreap::contains(
  self : PersistentTreap[K, V],
  key : K,
) -> Bool {
  match self.get(key) {
    Some(_) => true
    None => false
  }
}

///|
pub fn[K : Compare, V] PersistentTreap::remove(
  self : PersistentTreap[K, V],
  key : K,
) -> (PersistentTreap[K, V], Bool) {
  let (new_root, removed) = remove_node(self.root, key)
  let size = if removed { self.size - 1 } else { self.size }
  (
    PersistentTreap::{ root: new_root, size, rng_state: self.rng_state },
    removed,
  )
}

///|
pub impl[K, V] Default for PersistentTreap[K, V] with default() {
  PersistentTreap::new()
}
