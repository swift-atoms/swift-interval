import Interval_Boundary
import Testing

@Suite
struct `Interval Boundary Tests` {
    @Test
    func `boundary toggles inclusion`() {
        #expect(Interval::Interval.Boundary.closed.toggled == .open)
    }
}
