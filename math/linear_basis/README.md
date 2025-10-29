# Linear Basis

This module implements a binary linear basis for XOR operations. The structure
stores one representative for every leading bit and supports:

- inserting values while keeping only linearly independent vectors,
- reducing arbitrary numbers against the basis,
- maximizing XOR results with or without a seed value,
- extracting the 1-indexed k-th largest value in descending order,
- checking membership and inspecting the current basis state.

It is useful for problems such as finding maximum subset XOR, answering online
XOR queries, or verifying linear independence over GF(2).

