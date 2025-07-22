test {
    let dsu = DSU::new(3)
    let flag = dsu.merge(1, 2)
    inspect(flag, content="true")
    assert_eq(dsu.find(1), dsu.find(2))
    let sz = dsu.size(1)
    inspect(sz, content="2")
  }
