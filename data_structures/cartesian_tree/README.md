# Cartesian Tree

A **Cartesian Tree** is a binary tree constructed from a sequence such that:

- The in-order traversal of the tree reproduces the original sequence.
- Each node obeys the heap property (this implementation keeps the minimum element at the root).

This MoonBit module exposes a lightweight API to build and inspect Cartesian Trees using index
arrays, making it convenient to plug into algorithms such as range minimum queries, lowest common
ancestor preprocessing, and RMQ sparse tables.

## ✨ Features

- **Deterministic construction** using the classic stack-based linear-time algorithm.
- **Index-friendly representation** via parallel arrays for parents and children, simplifying
  integration with array-based workflows.
- **Explicit optional links**: child and parent pointers are stored as `Int?`, avoiding sentinel
  values and clarifying when a relationship is absent.
- **Utility helpers** for retrieving children, parents, or the in-order traversal of the tree.

