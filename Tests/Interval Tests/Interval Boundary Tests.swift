import Interval
import Testing

@Suite
struct `Interval boundaries toggle endpoint inclusion` {
    @Test
    func `boundary toggles inclusion`() {
        #expect(Interval.Boundary.closed.toggled == .open)
    }
}
