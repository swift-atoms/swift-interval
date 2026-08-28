public import Interval
public import Pair

extension Interval::Interval {

    public enum Bound: Sendable, Hashable, CaseIterable {

        case lower

        case upper
    }
}

extension Interval::Interval.Bound {

    @inlinable
    public static func opposite(of bound: Interval::Interval.Bound) -> Interval::Interval.Bound {
        switch bound {
        case .lower: return .upper
        case .upper: return .lower
        }
    }

    @inlinable
    public var opposite: Interval::Interval.Bound {
        Self.opposite(of: self)
    }

    @inlinable
    public static prefix func ! (value: Interval::Interval.Bound) -> Interval::Interval.Bound {
        value.opposite
    }
}

extension Interval::Interval.Bound {

    public static var min: Interval::Interval.Bound { .lower }

    public static var max: Interval::Interval.Bound { .upper }

    public static var left: Interval::Interval.Bound { .lower }

    public static var right: Interval::Interval.Bound { .upper }
}

extension Interval::Interval.Bound {

    public typealias Value<Payload> = Pair<Interval::Interval.Bound, Payload>
}

#if !hasFeature(Embedded)
    extension Interval::Interval.Bound: Codable {}
#endif
