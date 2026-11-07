import Interval
import Testing

enum `Interval Boundary Tests` {}

extension `Interval Boundary Tests` {
    @Suite
    struct `Interval boundaries toggle endpoint inclusion` {
        @Test
        func `boundary toggles inclusion`() {
            #expect(Interval.Boundary.closed.toggled == .open)
        }
    }
}
