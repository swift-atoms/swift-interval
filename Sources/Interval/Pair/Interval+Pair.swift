#if Pair
public import Pair

extension Interval.Bound {

    public typealias Value<Payload: ~Copyable & ~Escapable> = Pair<Interval.Bound, Payload>
}

extension Interval.Boundary {

    public typealias Value<Payload: ~Copyable & ~Escapable> = Pair<Interval.Boundary, Payload>
}

extension Interval.Endpoint {

    public typealias Value<Payload: ~Copyable & ~Escapable> = Pair<Interval.Endpoint, Payload>
}
#endif
