import Interval_Bound
import Testing

@Suite
struct `Interval Bound Tests` {
    @Test
    func `bounds are opposites`() {
        #expect(Interval::Interval.Bound.lower.opposite == .upper)
    }
}
