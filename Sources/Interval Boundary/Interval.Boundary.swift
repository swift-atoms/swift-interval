public import Interval_Primitive
public import Pair

extension Interval {

    public enum Boundary: Sendable, Hashable, CaseIterable {

        case closed

        case open
    }
}

extension Interval.Boundary {

    @inlinable
    public static func opposite(of boundary: Interval.Boundary) -> Interval.Boundary {
        switch boundary {
        case .closed: return .open
        case .open: return .closed
        }
    }

    @inlinable
    public var opposite: Interval.Boundary {
        Self.opposite(of: self)
    }

    @inlinable
    public static prefix func ! (value: Interval.Boundary) -> Interval.Boundary {
        value.opposite
    }

    @inlinable
    public var toggled: Interval.Boundary { opposite }
}

extension Interval.Boundary {

    @inlinable
    public var isInclusive: Bool { self == .closed }

    @inlinable
    public var isExclusive: Bool { self == .open }
}

extension Interval.Boundary {

    public typealias Value<Payload> = Pair<Interval.Boundary, Payload>
}

#if !hasFeature(Embedded)
    extension Interval.Boundary: Codable {}
#endif
