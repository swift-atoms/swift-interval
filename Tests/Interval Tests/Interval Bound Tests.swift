import Interval
import Testing

@Suite
struct `Interval bounds exchange lower and upper positions` {
    @Test
    func `bounds are opposites`() {
        #expect(Interval.Bound.lower.opposite == .upper)
    }
}
