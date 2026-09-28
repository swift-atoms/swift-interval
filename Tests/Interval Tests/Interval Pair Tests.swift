#if Pair
import Interval
import Testing

@Suite
struct `Interval labels compose with payloads through Pair` {
    @Test
    func `Bound Value pairs a bound with a payload`() {
        let labelled: Interval.Bound.Value<Int> = Pair(.lower, 0)
        #expect(labelled.first == .lower)
        #expect(labelled.second == 0)
    }

    @Test
    func `Boundary Value pairs a boundary with a payload`() {
        let labelled: Interval.Boundary.Value<String> = Pair(.closed, "included")
        #expect(labelled.first == .closed)
        #expect(labelled.second == "included")
    }

    @Test
    func `Endpoint Value pairs an endpoint with a payload`() {
        let labelled: Interval.Endpoint.Value<Bool> = Pair(.end, true)
        #expect(labelled.first == .end)
        #expect(labelled.second)
    }

    @Test
    func `Value preserves Pair noncopyable payload support`() {
        struct Payload: ~Copyable {
            let value: Int
        }

        let labelled: Interval.Endpoint.Value<Payload> = Pair(.start, Payload(value: 7))
        #expect(labelled.first == .start)
        #expect(labelled.second.value == 7)
    }

    @Test
    func `Every label preserves a borrowed span without copying its elements`() {
        let values = [13, 21, 34]
        let bound: Interval.Bound.Value<Span<Int>> = Pair(.upper, values.span)
        let boundary: Interval.Boundary.Value<Span<Int>> = Pair(.open, values.span)
        let endpoint: Interval.Endpoint.Value<Span<Int>> = Pair(.start, values.span)
        #expect(bound.first == .upper)
        #expect(bound.second[0] == 13)
        #expect(boundary.first == .open)
        #expect(boundary.second[1] == 21)
        #expect(endpoint.first == .start)
        #expect(endpoint.second[2] == 34)
    }

    @Test
    func `Every label releases its noncopyable payload when consumed`() {
        final class Sentinel {}
        struct Payload: ~Copyable {
            let sentinel: Sentinel
        }
        weak var first: Sentinel?
        weak var second: Sentinel?
        weak var third: Sentinel?
        do {
            let value = Sentinel()
            first = value
            let bound: Interval.Bound.Value<Payload> = Pair(.lower, Payload(sentinel: value))
            let mapped = bound.map(second: { (payload: consuming Payload) in 1 })
            #expect(mapped.first == .lower)
            #expect(mapped.second == 1)
        }
        do {
            let value = Sentinel()
            second = value
            let boundary: Interval.Boundary.Value<Payload> = Pair(.closed, Payload(sentinel: value))
            let mapped = boundary.map(second: { (payload: consuming Payload) in 2 })
            #expect(mapped.first == .closed)
            #expect(mapped.second == 2)
        }
        do {
            let value = Sentinel()
            third = value
            let endpoint: Interval.Endpoint.Value<Payload> = Pair(.end, Payload(sentinel: value))
            let mapped = endpoint.map(second: { (payload: consuming Payload) in 3 })
            #expect(mapped.first == .end)
            #expect(mapped.second == 3)
        }
        #expect(first == nil)
        #expect(second == nil)
        #expect(third == nil)
    }
}
#endif
