#if Finite
public import Cardinal
public import Finite
import Index
public import Ordinal
import Tagged

extension Interval.Bound: Finite.Enumerable {

    @inlinable
    public static var count: Cardinal { Cardinal(2) }

    @inlinable
    public var ordinal: Ordinal {
        switch self {
        case .lower: Ordinal(0)
        case .upper: Ordinal(1)
        }
    }

    @inlinable
    public init(_unchecked: Void, ordinal: Ordinal) {
        switch ordinal.rawValue {
        case 0: self = .lower
        default: self = .upper
        }
    }
}
#endif
