# Persistent Segment Tree

A persistent segment tree that supports point updates and range queries while
preserving previous versions of the tree.

Each update returns a new tree instance. The old versions remain valid and can
still be queried, which is useful for time-travel queries or offline processing.

