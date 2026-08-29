import Testing

@testable import Interval_Unit

@Suite
struct `Interval Unit - Initialization` {

    @Test
    func `checked init accepts values in the unit interval`() {
        let zero: Double = 0.0
        let half: Double = 0.5
        let one: Double = 1.0
        #expect(Interval.Unit<Double>(zero) != nil)
        #expect(Interval.Unit<Double>(half)?.underlying == 0.5)
        #expect(Interval.Unit<Double>(one) != nil)
    }

    @Test
    func `checked init rejects values outside the unit interval`() {
        let below: Double = -0.1
        let above: Double = 1.1
        #expect(Interval.Unit<Double>(below) == nil)
        #expect(Interval.Unit<Double>(above) == nil)
        #expect(Interval.Unit<Double>(Double.infinity) == nil)
        #expect(Interval.Unit<Double>(Double.nan) == nil)
    }

    @Test
    func `clamping init clamps into the unit interval`() {
        #expect(Interval.Unit<Double>(clamping: -1.0).underlying == 0.0)
        #expect(Interval.Unit<Double>(clamping: 0.25).underlying == 0.25)
        #expect(Interval.Unit<Double>(clamping: 2.0).underlying == 1.0)
        #expect(Interval.Unit<Double>(clamping: .nan).underlying == 0.0)
    }
}

@Suite
struct `Interval Unit - Operations` {

    @Test
    func `complement is an involution`() {
        let value: Interval.Unit<Double> = 0.25
        #expect(value.complement.underlying == 0.75)
        #expect(value.complement.complement == value)
    }

    @Test
    func `interpolation blends endpoints`() {
        let start: Interval.Unit<Double> = 0.0
        let end: Interval.Unit<Double> = 1.0
        #expect(start.interpolated(to: end, at: .half).underlying == 0.5)
        #expect(start.interpolated(to: end, at: .zero) == start)
        #expect(start.interpolated(to: end, at: .one) == end)
    }

    @Test
    func `multiplication stays in the unit interval`() {
        let half: Interval.Unit<Double> = .half
        #expect((half * half).underlying == 0.25)
        var value: Interval.Unit<Double> = .one
        value *= half
        #expect(value == .half)
    }

    @Test
    func `constants carry expected values`() {
        #expect(Interval.Unit<Double>.zero.underlying == 0.0)
        #expect(Interval.Unit<Double>.half.underlying == 0.5)
        #expect(Interval.Unit<Double>.one.underlying == 1.0)
    }

    @Test
    func `comparable orders by underlying value`() {
        #expect(Interval.Unit<Double>.zero < .half)
        #expect(Interval.Unit<Double>.half < .one)
    }
}

@Suite
struct `Interval Unit - Aliases` {

    @Test
    func `Opacity and Alpha alias the unit interval`() {
        let opacity: Opacity<Double> = 0.5
        let alpha: Alpha<Double> = 0.5
        #expect(opacity == alpha)
        #expect(opacity.underlying == 0.5)
    }
}
