# Heap
A generic binary heap (priority queue) implemented in the [MoonBit](https://www.moonbitlang.com/) language.

This implementation supports a **custom comparator**, so you can build either a **min-heap** or **max-heap**, or any domain-specific ordering. It aims to be a clean, robust, and idiomatic template for reuse.

## ✨ Features
- **Generic**: Works with any type `T`.
- **Customizable Ordering**: Provide `(T, T) -> Bool` to define heap priority.
- **Linear Build**: `from_vec` constructs the heap in `O(n)`.
- **Logarithmic Ops**: `add`（push）与 `pop`（extract-top）均为 `O(log n)`.
- **Safe API**: `pop` 返回 `T?`，空堆时安全退出。

## ✅ Requirements
- 使用 MoonBit 动态数组作为底层存储。
- 你需要提供一个比较器 `cmp : (T, T) -> Bool`，其中 `cmp(a, b) = true` 表示 **a 的优先级高于 b**。  
  - 最小堆：`fn(a, b) { a < b }`  
  - 最大堆：`fn(a, b) { a > b }`

## 🧩 API Overview
```moonbit
pub struct Heap[T] {
  items : Array[T]
  comparator : (T, T) -> Bool
}

pub fn[T] Heap::new(comparator : (T, T) -> Bool) -> Heap[T]
pub fn[T] Heap::from_vec(items : Array[T], comparator : (T, T) -> Bool) -> Heap[T]
pub fn[T] Heap::build_heap(self : Heap[T]) -> Unit

pub fn[T] Heap::len(self : Heap[T]) -> Int
pub fn[T] Heap::is_empty(self : Heap[T]) -> Bool
pub fn[T] Heap::add(self : Heap[T], value : T) -> Unit         // push
pub fn[T] Heap::pop(self : Heap[T]) -> T?                      // extract top or None
pub fn[T] Heap::iter(self : Heap[T]) -> Iter[T]                // internal order (not sorted)

