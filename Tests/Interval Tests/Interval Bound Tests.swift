import Interval
import Testing

@Suite
struct `Interval Bound Tests` {
    @Test
    func `bounds are opposites`() {
        #expect(Interval.Bound.lower.opposite == .upper)
    }
}
