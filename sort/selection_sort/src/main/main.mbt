///The following are tests that do not use test
fn main {
  // 测试1: 空数组
  let test_empty = Array::make(0, 0)
  @lib.sort(test_empty)
  
  println("Test empty: ")
  println(Bool::to_string(@lib.is_sorted(test_empty))) // 应输出true

  // 测试2: 单个元素
  let test_single = Array::make(1, 42)
  @lib.sort(test_single)
  println("Test single: ")
  println(Bool::to_string(@lib.is_sorted(test_single)))

  // 测试3: 已排序数组
  let test_sorted = Array::make(5, 0)
  test_sorted[0] = 1; test_sorted[1] = 2; test_sorted[2] = 3; test_sorted[3] = 4; test_sorted[4] = 5
  @lib.sort(test_sorted)
  println("Test sorted: ")
  println(Bool::to_string(@lib.is_sorted(test_sorted)))
  // 测试4: 逆序数组
  let test_reverse = Array::make(5, 0)
  test_reverse[0] = 5; test_reverse[1] = 4; test_reverse[2] = 3; test_reverse[3] = 2; test_reverse[4] = 1
  
  @lib.sort(test_reverse)
  println("Test reverse: ")
  println(Bool::to_string(@lib.is_sorted(test_reverse)))

  // 测试5: 全相同元素
  let test_duplicates = Array::make(4, 0)
  test_duplicates[0] = 7;test_duplicates[1] = 7;test_duplicates[2] = 7;test_duplicates[3] = 7
  @lib.sort(test_duplicates)
  println("Test duplicates: ")
  println(Bool::to_string(@lib.is_sorted(test_duplicates)))

  // 测试6: 包含负数
  let test_negatives = {
  let arr = Array::make(5, 0)  // 创建5元素数组
  arr[0] = -3
  arr[1] = -1
  arr[2] = -4
  arr[3] = 0
  arr[4] = 2
  arr  // 返回初始化完成的数组
                                  }
  @lib.sort(test_negatives)
  println("Test negatives: ")
  println(Bool::to_string(@lib.is_sorted(test_negatives)))

  // 测试7: 大规模数据 (1000个随机数)
  let large_array = Array::make(1000, 0)
  let mut i = 0
  while i < 1000 {
    large_array[i] = (i % 300) * (if i % 2 == 0 { 1 } else { -1 })
    i += 1
  }
  @lib.sort(large_array)
  println("Test large scale: ")
  println(Bool::to_string(@lib.is_sorted(large_array)))

  // 测试8: 最小最大值边界
  let test_boundary = {
  let arr = Array::make(2, 0)
  arr[0] = 2147483647  // Int最大值
  arr[1] = -2147483648 // Int最小值
  arr
                                  }
  @lib.sort(test_boundary)
  println("Test boundary: ")
  println(Bool::to_string(@lib.is_sorted(test_boundary)))

}