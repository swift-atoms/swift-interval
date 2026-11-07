import Interval
import Testing

enum `Interval Bound Tests` {}

extension `Interval Bound Tests` {
    @Suite
    struct `Interval bounds exchange lower and upper positions` {
        @Test
        func `bounds are opposites`() {
            #expect(Interval.Bound.lower.opposite == .upper)
        }
    }
}
