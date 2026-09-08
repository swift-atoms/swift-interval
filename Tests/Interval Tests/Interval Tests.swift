import Interval
import Testing

@Suite
struct `The Interval namespace has zero size` {
    @Test
    func `interval namespace is empty`() {
        #expect(MemoryLayout<Interval>.size == 0)
    }
}
