import Cardinal
import Difference
import Foundation
import Interval
import Ordinal
import Tagged
import Testing

private enum Slot {}

private typealias SlotPosition = Tagged<Slot, Ordinal>
private typealias SlotCount = Tagged<Slot, Cardinal>
private typealias SlotOffset = Tagged<Slot, Difference>

private struct CodablePosition: Ordinal.`Protocol`, Codable, Comparable, Sendable {
    typealias Domain = Never
    typealias Count = Cardinal
    typealias Offset = Difference

    let rawValue: UInt

    var ordinal: Ordinal { Ordinal(rawValue) }

    init(_ ordinal: Ordinal) {
        self.rawValue = ordinal.rawValue
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

private struct EncodedEndpoints: Encodable {
    let start: CodablePosition
    let end: CodablePosition
}

@Suite
struct `Discrete intervals preserve validated extents through translation and persistence` {

    @Test
    func `start and count form a half-open interval`() throws {
        let interval = try Interval.Discrete(start: Ordinal(5), count: Cardinal(3))

        #expect(interval.start == 5)
        #expect(interval.end == 8)
        #expect(interval.count == 3)
        #expect(interval.contains(Ordinal(5)))
        #expect(interval.contains(Ordinal(7)))
        #expect(!interval.contains(Ordinal(4)))
        #expect(!interval.contains(Ordinal(8)))
    }

    @Test
    func `reversed endpoints are rejected`() {
        #expect(throws: Interval.Discrete<Ordinal>.Error.reversed) {
            try Interval.Discrete(start: Ordinal(8), end: Ordinal(5))
        }
    }

    @Test
    func `empty interval is valid at the greatest position`() throws {
        let interval = try Interval.Discrete(
            start: Ordinal(UInt.max),
            count: Cardinal.zero
        )

        #expect(interval.isEmpty)
        #expect(interval.end == Ordinal(UInt.max))
        #expect(!interval.contains(Ordinal(UInt.max)))
    }

    @Test
    func `nonempty interval beyond greatest position is rejected`() {
        #expect(throws: Interval.Discrete<Ordinal>.Error.overflow) {
            try Interval.Discrete(start: Ordinal(UInt.max), count: Cardinal.one)
        }
    }

    @Test
    func `translation preserves count`() throws {
        let interval = try Interval.Discrete(start: Ordinal(5), count: Cardinal(3))
        let translated = try interval.translated(by: Difference(-2))

        #expect(translated.start == 3)
        #expect(translated.end == 6)
        #expect(translated.count == interval.count)
    }

    @Test
    func `translation rejects endpoint underflow`() throws {
        let interval = try Interval.Discrete(start: Ordinal(2), count: Cardinal(3))

        #expect(throws: Ordinal.Error.underflow) {
            try interval.translated(by: Difference(-3))
        }
    }

    @Test
    func `translation rejects exclusive endpoint overflow`() throws {
        let interval = try Interval.Discrete(
            start: Ordinal(UInt.max - 2),
            end: Ordinal(UInt.max)
        )

        #expect(throws: Ordinal.Error.overflow) {
            try interval.translated(by: Difference(1))
        }
    }

    @Test
    func `tagged translation preserves position count and offset domains`() throws {
        let start = SlotPosition(_unchecked: Ordinal(4))
        let count = SlotCount(_unchecked: Cardinal(3))
        let offset = SlotOffset(_unchecked: Difference(2))
        let interval = try Interval.Discrete(start: start, count: count)
        let translated: Interval.Discrete<SlotPosition> =
            try interval.translated(by: offset)

        #expect(translated.start == SlotPosition(_unchecked: Ordinal(6)))
        #expect(translated.end == SlotPosition(_unchecked: Ordinal(9)))
        #expect(translated.count == count)
    }

    @Test
    func `range conversions preserve endpoints`() throws {
        let source = Ordinal(3)..<Ordinal(7)
        let interval = try Interval.Discrete(source)
        let property = interval.range
        let initialized = Range(interval)

        #expect(property == source)
        #expect(initialized == source)
        #expect(interval.count == Cardinal(4))
    }

    @Test
    func `semantic endpoint equality and hashing ignore count reconstruction`() throws {
        let byCount = try Interval.Discrete(start: Ordinal(2), count: Cardinal(4))
        let byEndpoints = try Interval.Discrete(start: Ordinal(2), end: Ordinal(6))

        #expect(byCount == byEndpoints)
        #expect(Set([byCount, byEndpoints]).count == 1)
    }

    @Test
    func `Codable round trip validates endpoints`() throws {
        let interval = try Interval.Discrete(
            start: CodablePosition(Ordinal(3)),
            end: CodablePosition(Ordinal(8))
        )
        let encoded = try JSONEncoder().encode(interval)
        let decoded = try JSONDecoder().decode(
            Interval.Discrete<CodablePosition>.self,
            from: encoded
        )

        #expect(decoded == interval)
        #expect(decoded.count == Cardinal(5))
    }

    @Test
    func `Codable rejects reversed endpoints`() throws {
        let malformed = EncodedEndpoints(
            start: CodablePosition(Ordinal(8)),
            end: CodablePosition(Ordinal(3))
        )
        let encoded = try JSONEncoder().encode(malformed)

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(
                Interval.Discrete<CodablePosition>.self,
                from: encoded
            )
        }
    }
}
