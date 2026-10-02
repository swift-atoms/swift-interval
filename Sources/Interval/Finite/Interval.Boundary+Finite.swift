#if Finite
public import Cardinal
public import Finite
import Index
public import Ordinal
import Tagged

extension Interval.Boundary: Finite.Enumerable {

    @inlinable
    public static var count: Cardinal { Cardinal(2) }

    @inlinable
    public var ordinal: Ordinal {
        switch self {
        case .closed: Ordinal(0)
        case .open: Ordinal(1)
        }
    }

    @inlinable
    public init(_unchecked: Void, ordinal: Ordinal) {
        switch ordinal.rawValue {
        case 0: self = .closed
        default: self = .open
        }
    }
}
#endif
