///|
pub extend ChthollyTree with @debug.Debug::{to_repr}

///|
pub extend ChthollyTree with Default::{default}

///|
pub extend ChthollyTreeError with @debug.Debug::{to_repr}

///|
pub extend ChthollyTreeError with Eq::{not_equal, equal}

///|
pub extend Interval with @debug.Debug::{to_repr}

///|
pub extend Interval with Eq::{not_equal, equal}
