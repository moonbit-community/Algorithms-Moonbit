# Queue
A mutable FIFO queue implemented in the [MoonBit](https://www.moonbitlang.com/) language.

This implementation uses a dynamic array plus a moving **start** index to achieve amortized `O(1)` push/pop, with an API that feels familiar to imperative languages while staying idiomatic to MoonBit.

---

## ✨ Features
- **Generic** over `T`
- **Amortized O(1)** push / pop using a sliding window (`start` pointer)
- **Zero-copy front/back access** via references (`Ref[T]?`)
- **Clear & Default** helpers for easy lifecycle management

---

## 🧩 API Overview

```moonbit
pub struct Queue[T] {
  elements : Array[T]
  mut start : Int
}

pub fn[T : Default] Queue::new() -> Queue[T]

pub fn[T] Queue::push(self : Queue[T], value : T) -> Unit

pub fn[T] Queue::pop(self : Queue[T]) -> T?          // None if empty

pub fn[T] Queue::front(self : Queue[T]) -> Ref[T]?    // None if empty

pub fn[T] Queue::back(self : Queue[T]) -> Ref[T]?     // None if empty

pub fn[T] Queue::len(self : Queue[T]) -> Int

pub fn[T] Queue::is_empty(self : Queue[T]) -> Bool

pub fn[T] Queue::clear(self : Queue[T]) -> Unit

pub impl[T : Default] Default for Queue[T] with default() -> Queue[T]
```
