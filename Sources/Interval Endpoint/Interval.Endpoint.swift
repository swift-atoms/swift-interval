public import Interval
public import Pair

extension Interval::Interval {

    public enum Endpoint: Sendable, Hashable, CaseIterable {

        case start

        case end
    }
}

extension Interval::Interval.Endpoint {

    @inlinable
    public static func opposite(
        of endpoint: Interval::Interval.Endpoint
    ) -> Interval::Interval.Endpoint {
        switch endpoint {
        case .start: return .end
        case .end: return .start
        }
    }

    @inlinable
    public var opposite: Interval::Interval.Endpoint {
        Self.opposite(of: self)
    }

    @inlinable
    public static prefix func ! (value: Interval::Interval.Endpoint) -> Interval::Interval.Endpoint {
        value.opposite
    }
}

extension Interval::Interval.Endpoint {

    public static var first: Interval::Interval.Endpoint { .start }

    public static var last: Interval::Interval.Endpoint { .end }

    public static var head: Interval::Interval.Endpoint { .start }

    public static var tail: Interval::Interval.Endpoint { .end }
}

extension Interval::Interval.Endpoint {

    public typealias Value<Payload> = Pair<Interval::Interval.Endpoint, Payload>
}

#if !hasFeature(Embedded)
    extension Interval::Interval.Endpoint: Codable {}
#endif
