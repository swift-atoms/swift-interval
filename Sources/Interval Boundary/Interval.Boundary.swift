public import Interval
public import Pair

extension Interval::Interval {

    public enum Boundary: Sendable, Hashable, CaseIterable {

        case closed

        case open
    }
}

extension Interval::Interval.Boundary {

    @inlinable
    public static func opposite(
        of boundary: Interval::Interval.Boundary
    ) -> Interval::Interval.Boundary {
        switch boundary {
        case .closed: return .open
        case .open: return .closed
        }
    }

    @inlinable
    public var opposite: Interval::Interval.Boundary {
        Self.opposite(of: self)
    }

    @inlinable
    public static prefix func ! (value: Interval::Interval.Boundary) -> Interval::Interval.Boundary {
        value.opposite
    }

    @inlinable
    public var toggled: Interval.Boundary { opposite }
}

extension Interval::Interval.Boundary {

    @inlinable
    public var isInclusive: Bool { self == .closed }

    @inlinable
    public var isExclusive: Bool { self == .open }
}

extension Interval::Interval.Boundary {

    public typealias Value<Payload> = Pair<Interval::Interval.Boundary, Payload>
}

#if !hasFeature(Embedded)
    extension Interval::Interval.Boundary: Codable {}
#endif
