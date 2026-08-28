import Interval_Endpoint
import Testing

@Suite
struct `Interval Endpoint Tests` {
    @Test
    func `endpoints are opposites`() {
        #expect(Interval::Interval.Endpoint.start.opposite == .end)
    }
}
