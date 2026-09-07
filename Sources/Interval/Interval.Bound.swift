extension Interval {

    public enum Bound: Sendable, Hashable, CaseIterable {

        case lower

        case upper
    }
}

extension Interval.Bound {

    @inlinable
    public static func opposite(of bound: Interval.Bound) -> Interval.Bound {
        switch bound {
        case .lower: return .upper
        case .upper: return .lower
        }
    }

    @inlinable
    public var opposite: Interval.Bound {
        Self.opposite(of: self)
    }

    @inlinable
    public static prefix func ! (value: Interval.Bound) -> Interval.Bound {
        value.opposite
    }
}

extension Interval.Bound {

    public static var min: Interval.Bound { .lower }

    public static var max: Interval.Bound { .upper }

    public static var left: Interval.Bound { .lower }

    public static var right: Interval.Bound { .upper }
}

#if !hasFeature(Embedded)
extension Interval.Bound: Swift.Codable {}
#endif
