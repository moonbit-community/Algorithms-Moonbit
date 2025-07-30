test "segment_tree_sum_test" {
    let arr = [1, 2, -4, 7, 3, -5, 6, 11, -20, 9, 14, 15, 5, 2, -8];
    let max_seg = SegmentTree::from_array(arr,fn(a,b) {a+b})
     inspect(max_seg.query(0,14).unwrap(), content = "Some(38)")
     inspect(max_seg.query(1,3).unwrap(), content = "Some(5)")
     inspect(max_seg.query(4,6).unwrap(), content = "Some(4)")
     inspect(max_seg.query(6,8).unwrap(), content = "Some(-3)")
     inspect(max_seg.query(9,14).unwrap(), content = "Some(37)")
    inspect(max_seg.update(5, 10).unwrap(), content = "()");
      inspect(max_seg.update(14, -8).unwrap(), content = "()")
     inspect(max_seg.query(4,7).unwrap(), content = "Some(30)")
     inspect(max_seg.update(15,100),content = "Err(IndexOutOfBounds)")
     inspect(max_seg.query(15,20),content = "Err(InvalidRange)")
  }


test "segment_tree_min_test" {
    let arr = [-30, 2, -4, 7, 3, -5, 6, 11, -20, 9, 14, 15, 5, 2, -8]
    let max_seg = SegmentTree::from_array(arr,@cmp.minimum)
     inspect(max_seg.query(0,14).unwrap(), content = "Some(-30)")
     inspect(max_seg.query(0,1).unwrap(), content = "Some(-30)")
     inspect(max_seg.query(4,6).unwrap(), content = "Some(-5)")
     inspect(max_seg.query(1,2).unwrap(), content = "Some(-4)")
     inspect(max_seg.query(1,6).unwrap(), content = "Some(-5)")
    inspect(max_seg.update(5, 10).unwrap(), content = "()");
      inspect(max_seg.update(14, -8).unwrap(), content = "()")
     inspect(max_seg.query(4,6).unwrap(), content = "Some(3)")
     inspect(max_seg.update(15,100),content = "Err(IndexOutOfBounds)")
     inspect(max_seg.query(15,20),content = "Err(InvalidRange)")
  }


test "segment_tree_max_test" {
    let arr = [1, 2, -4, 7, 3, -5, 6, 11, -20, 9, 14, 15, 5, 2, -8]
    let max_seg = SegmentTree::from_array(arr,@cmp.maximum)
     inspect(max_seg.query(0,14).unwrap(), content = "Some(15)")
     inspect(max_seg.query(3,4).unwrap(), content = "Some(7)")
     inspect(max_seg.query(4,7).unwrap(), content = "Some(11)")
     inspect(max_seg.query(8,9).unwrap(), content = "Some(9)")
     inspect(max_seg.query(9,11).unwrap(), content = "Some(15)")
    inspect(max_seg.update(4, 10).unwrap(), content = "()");
      inspect(max_seg.update(14, -8).unwrap(), content = "()")
     inspect(max_seg.query(3,4).unwrap(), content = "Some(10)")
     inspect(max_seg.update(15,100),content = "Err(IndexOutOfBounds)")
     inspect(max_seg.query(15,20),content = "Err(InvalidRange)")
  }
