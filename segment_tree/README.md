# Segment Tree
A generic Segment Tree data structure implemented in the [MoonBit](https://www.moonbitlang.com/) language.

This implementation supports custom merge operations, making it easy to apply to a variety of problems such as range sum, range minimum/maximum (RMQ), range GCD, and more. It is designed to be a clean, robust, and idiomatic template for this powerful data structure.

## ✨ Features

- **Generic**: Works with any type `T` that satisfies the necessary traits (`Copy`, `Default`).
- **Customizable Operations**: The behavior of the tree is defined by a user-provided `merge` function, allowing for maximum flexibility.
- **Efficient Performance**: Both point updates and range queries have a time complexity of `O(log n)`.
- **Safe Error Handling**: The `query` and `update` methods return a `Result` type to handle invalid inputs gracefully.
