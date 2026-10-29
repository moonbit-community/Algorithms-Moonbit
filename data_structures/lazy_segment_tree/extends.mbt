///|
pub extend LazySegmentTree with @debug.Debug::{to_repr}

///|
pub extend LazySegmentTreeError with @debug.Debug::{to_repr}

///|
pub extend LazySegmentTreeError with Eq::{not_equal, equal}

///|
pub extend LazySegmentTreeError with Show::{to_string, output}
