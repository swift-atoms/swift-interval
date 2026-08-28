import Interval
import Testing

@Suite
struct `Interval Tests` {
    @Test
    func `interval namespace is empty`() {
        #expect(MemoryLayout<Interval::Interval>.size == 0)
    }
}
