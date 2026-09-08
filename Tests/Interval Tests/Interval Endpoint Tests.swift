import Interval
import Testing

@Suite
struct `Interval endpoints exchange their opposing cases` {
    @Test
    func `endpoints are opposites`() {
        #expect(Interval.Endpoint.start.opposite == .end)
    }
}
