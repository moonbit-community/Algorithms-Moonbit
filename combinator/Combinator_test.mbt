test {
    let comb = Comb::new(2_000_000,1000000007)
    inspect(comb.c(4,2), content="6")
    inspect(comb.a(4,2), content="12")
    inspect(comb.c(1_000_000,500_000), content="996692777")
  }
