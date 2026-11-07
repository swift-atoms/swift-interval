import Interval
import Testing

enum `Interval Endpoint Tests` {}

extension `Interval Endpoint Tests` {
    @Suite
    struct `Interval endpoints exchange their opposing cases` {
        @Test
        func `endpoints are opposites`() {
            #expect(Interval.Endpoint.start.opposite == .end)
        }
    }
}
