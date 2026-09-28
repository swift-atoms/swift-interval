#if Finite
public import Cardinal
public import Finite
public import Index
public import Ordinal
public import Tagged

extension Interval.Endpoint: Finite.Enumerable {

    @inlinable
    public static var count: Cardinal { Cardinal(2) }

    @inlinable
    public var ordinal: Ordinal {
        switch self {
        case .start: Ordinal(0)
        case .end: Ordinal(1)
        }
    }

    @inlinable
    public init(_unchecked: Void, ordinal: Ordinal) {
        switch ordinal.rawValue {
        case 0: self = .start
        default: self = .end
        }
    }
}
#endif
