extension Interval {

    public enum Endpoint: Sendable, Hashable, CaseIterable {

        case start

        case end
    }
}

extension Interval.Endpoint {

    @inlinable
    public static func opposite(
        of endpoint: Interval.Endpoint
    ) -> Interval.Endpoint {
        switch endpoint {
        case .start: return .end
        case .end: return .start
        }
    }

    @inlinable
    public var opposite: Interval.Endpoint {
        Self.opposite(of: self)
    }

    @inlinable
    public static prefix func ! (value: Interval.Endpoint) -> Interval.Endpoint {
        value.opposite
    }
}

extension Interval.Endpoint {

    public static var first: Interval.Endpoint { .start }

    public static var last: Interval.Endpoint { .end }

    public static var head: Interval.Endpoint { .start }

    public static var tail: Interval.Endpoint { .end }
}

#if !hasFeature(Embedded)
extension Interval.Endpoint: Swift.Codable {}
#endif
