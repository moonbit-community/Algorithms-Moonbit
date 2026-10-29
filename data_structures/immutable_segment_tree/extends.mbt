///|
pub extend Node with @debug.Debug::{to_repr}

///|
pub extend PersistentSegmentTree with @debug.Debug::{to_repr}

///|
pub extend PersistentSegmentTree with Show::{to_string, output}

///|
pub extend PersistentSegmentTreeError with @debug.Debug::{to_repr}

///|
pub extend PersistentSegmentTreeError with Eq::{not_equal, equal}

///|
pub extend PersistentSegmentTreeError with Show::{to_string, output}
