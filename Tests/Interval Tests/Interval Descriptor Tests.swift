import Testing

@testable import Interval

@Suite
struct `Interval Bound` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Interval Bound`.Unit {
    @Test
    func `opposite swaps lower and upper`() {
        #expect(Interval.Bound.lower.opposite == .upper)
        #expect(Interval.Bound.upper.opposite == .lower)
        #expect(!Interval.Bound.lower == .upper)
    }

    @Test
    func `aliases resolve`() {
        #expect(Interval.Bound.min == .lower)
        #expect(Interval.Bound.max == .upper)
        #expect(Interval.Bound.left == .lower)
        #expect(Interval.Bound.right == .upper)
    }

    @Test
    func `case iterable`() {
        #expect(Interval.Bound.allCases == [.lower, .upper])
    }
}

@Suite
struct `Interval Boundary` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Interval Boundary`.Unit {
    @Test
    func `opposite swaps closed and open`() {
        #expect(Interval.Boundary.closed.opposite == .open)
        #expect(Interval.Boundary.open.toggled == .closed)
        #expect(!Interval.Boundary.closed == .open)
    }

    @Test
    func `inclusivity`() {
        #expect(Interval.Boundary.closed.isInclusive)
        #expect(Interval.Boundary.open.isExclusive)
    }
}

@Suite
struct `Interval Endpoint` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Interval Endpoint`.Unit {
    @Test
    func `opposite swaps start and end`() {
        #expect(Interval.Endpoint.start.opposite == .end)
        #expect(Interval.Endpoint.end.opposite == .start)
        #expect(!Interval.Endpoint.start == .end)
    }

    @Test
    func `aliases resolve`() {
        #expect(Interval.Endpoint.first == .start)
        #expect(Interval.Endpoint.last == .end)
        #expect(Interval.Endpoint.head == .start)
        #expect(Interval.Endpoint.tail == .end)
    }
}
