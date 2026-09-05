import Interval
import Testing

@Suite
struct `Interval Tests` {
    @Test
    func `interval namespace is empty`() {
        #expect(MemoryLayout<Interval>.size == 0)
    }
}
