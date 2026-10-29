///|
pub extend SegmentTree with @debug.Debug::{to_repr}

///|
pub extend SegmentTreeError with @debug.Debug::{to_repr}

///|
pub extend SegmentTreeError with Eq::{not_equal, equal}

///|
pub extend SegmentTreeError with Show::{to_string, output}
