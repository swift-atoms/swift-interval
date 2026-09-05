import Interval
import Testing

@Suite
struct `Interval Endpoint Tests` {
    @Test
    func `endpoints are opposites`() {
        #expect(Interval.Endpoint.start.opposite == .end)
    }
}
