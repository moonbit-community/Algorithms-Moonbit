pub enum SegmentTreeError {
    IndexOutOfBounds
    InvalidRange
}derive(Show,Eq)

pub struct SegmentTree[T] {
    size: Int
    nodes: Array[T]
    merge: (T, T) -> T
  }derive(Show)


///|Creates a new `SegmentTree` from the provided slice of elements.
/// 
/// # Parameters
/// 
/// - `arr` : A slice of elements of type `T` to initialize the segment tree.(0-based)
/// - `op` : A merging function that defines how to merge two elements of type `T`.
/// 
/// # Returns
/// 
/// - `SegmentTree` : A new `SegmentTree` instance populated with the given elements.
///
/// # Example
/// ```
///   let a1 = [1, 2, 3, 4, 5, 6]
///   let _ = SegmentTree::from_array(a1,@cmp.maximum)
/// ```
pub fn[T: Default] SegmentTree::from_array(arr: Array[T], merge: (T, T) -> T) -> SegmentTree[T] {
    let size = arr.length()
    let buffer: Array[T] = Array::make(2*size, T::default())
    for i in 0..<size {
        buffer[size+i] = arr[i]
      }
      for i = size - 1 ;i >= 1; i=i-1 {
          buffer[i] = merge(buffer[2*i], buffer[2*i+1])
        }
    SegmentTree:: {
        size,
        nodes: buffer,
        merge
    }
  }

///|Queries the segment tree for the result of merging the elements in the given range.
/// 
/// # Parameters
/// 
/// - `self` SegmentTree
/// - `left` : left point of the query range
/// - `right` : right point of the query range
/// 
/// # Returns
/// 
/// - `Ok(Some(result))` if the query was successful and there are elements in the range,
/// - `Ok(None)` if the range is empty,
/// - `Err(SegmentTreeError::InvalidRange)` if the provided range is invalid.
///
/// # Example
/// ```
///   let a1 = [1, 2, 3, 4, 5, 6]
///   let max_seg = SegmentTree::from_array(a1,@cmp.maximum)
///   inspect(max_seg.query(0,2).unwrap(), content = "Some(3)")
/// ```
pub fn[T] SegmentTree::query(self: SegmentTree[T], left: Int, right: Int) -> Result[Option[T],SegmentTreeError] {
    if left >= self.size || right >= self.size || left < 0 || right < 0{
        return Err(SegmentTreeError::InvalidRange)
      }
      let mut l = left + self.size
      let mut r = right + self.size + 1
      let mut res = None
      while l < r {
          if l % 2 == 1 {
              res = Some(match res {
                  None => self.nodes[l]
                  Some(old) => (self.merge)(old,self.nodes[l])
                }) 
              l += 1
            }
          if r % 2 == 1 {
              r -= 1
              res = Some(match res {
                  None => self.nodes[r]
                  Some(old) => (self.merge)(old, self.nodes[r])
                })
            }
          l /= 2
          r /= 2
        }
      Ok(res)
  }

///|Updates the value at the specified index in the segment tree.
/// 
/// # Parameters
/// 
/// - `self` SegmentTree
/// - `idx` : The index (0-based) of the element to update.
/// - `val` : The new value of type `T` to set at the specified index.
/// 
/// # Returns
/// 
/// - `Ok(())` if the update was successful,
/// - `Err(SegmentTreeError::IndexOutOfBounds)` if the index is out of bounds.
///
/// # Example
/// ```
///   let a1 = [1, 2, 3, 4, 5, 6]
///   let max_seg = SegmentTree::from_array(a1,@cmp.maximum)
///   inspect(max_seg.update(0,10).unwrap(), content = "()")
/// ```
pub fn[T: Eq] SegmentTree::update(self: SegmentTree[T], idx: Int, val: T) -> Result[Unit, SegmentTreeError] {
    if idx >= self.size || idx < 0 {
        return Err(SegmentTreeError::IndexOutOfBounds)
      }
    let mut index = idx+self.size
    if self.nodes[index] == val {
        return Ok(())
      }

    self.nodes[index] = val
    while index > 1 {
        index /= 2
        self.nodes[index] = (self.merge)(self.nodes[2*index], self.nodes[2*index+1])
      }
      Ok(())
  }
