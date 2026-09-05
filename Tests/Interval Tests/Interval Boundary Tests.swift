import Interval
import Testing

@Suite
struct `Interval Boundary Tests` {
    @Test
    func `boundary toggles inclusion`() {
        #expect(Interval.Boundary.closed.toggled == .open)
    }
}
