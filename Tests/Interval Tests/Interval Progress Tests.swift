import Interval
import Testing

enum `Interval Progress Tests` {}

extension `Interval Progress Tests` {
    @Suite
    struct `Progress through a closed range runs from 0 at the lower bound to 1 at the upper` {

        static let ranges: [ClosedRange<Double>] = [0...1, -3...5, 120...121.5, -1e6 ... -2]

        @Test(arguments: ranges)
        func `the bounds have progress 0 and 1`(range: ClosedRange<Double>) {
            #expect(range.progress(of: range.lowerBound) == 0)
            #expect(range.progress(of: range.upperBound) == 1)
            #expect(Interval.Unit(progress: range.lowerBound, through: range) == .zero)
            #expect(Interval.Unit(progress: range.upperBound, through: range) == .one)
        }

        @Test
        func `progress is linear inside and beyond the range`() {
            let range = -3.0...5.0
            #expect(range.progress(of: 1) == 0.5)
            #expect(range.progress(of: -7) == -0.5)
            #expect(range.progress(of: 9) == 1.5)
        }

        @Test(arguments: ranges)
        func `clamped progress stays in the unit interval`(range: ClosedRange<Double>) {
            for value in [-1e9, range.lowerBound - 1, range.lowerBound, range.upperBound + 7, 1e9, .infinity, -.infinity, .nan] {
                let progress = Interval.Unit(progress: value, through: range).underlying
                #expect(progress >= 0 && progress <= 1)
            }
            #expect(Interval.Unit(progress: .nan, through: range) == .zero)
        }

        @Test
        func `a range of one point is a step`() {
            let point = 2.0...2.0
            #expect(point.progress(of: 1.9) == 0)
            #expect(point.progress(of: 2) == 1)
            #expect(point.progress(of: 3) == 1)
            #expect(Interval.Unit(progress: 1.9, through: point) == .zero)
        }

        @Test
        func `clamped progress composes with interpolation back to the value`() {
            let range = 10.0...30.0
            let progress = Interval.Unit(progress: 15, through: range)
            #expect(progress.underlying == 0.25)
            #expect(range.lowerBound + (range.upperBound - range.lowerBound) * progress.underlying == 15)
        }
    }
}
