internal import Advancement
internal import Cardinal
internal import Carrier
public import Ordinal
internal import Subtraction

extension Interval {

    public struct Discrete<Position: Ordinal.`Protocol`> {
        public let start: Position

        public let end: Position

        public enum Error: Swift::Error, Hashable, Sendable {
            case reversed
            case overflow
        }

        public init(start: Position, count: Position.Count) throws(Error) {
            let end: UInt
            do {
                end = try Advancement.exact(
                    start.ordinal.rawValue,
                    by: count.cardinal.rawValue
                )
            } catch {
                throw .overflow
            }

            self.start = start
            self.end = Position(Ordinal(end))
        }

        public init(start: Position, end: Position) throws(Error) {
            guard start.ordinal.rawValue <= end.ordinal.rawValue else {
                throw .reversed
            }

            self.start = start
            self.end = end
        }

        private init(validatedStart start: Position, end: Position) {
            self.start = start
            self.end = end
        }
    }
}

extension Interval.Discrete: Swift::Sendable where Position: Swift::Sendable {}

extension Interval.Discrete: Swift::Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.start.ordinal.rawValue == rhs.start.ordinal.rawValue
            && lhs.end.ordinal.rawValue == rhs.end.ordinal.rawValue
    }
}

extension Interval.Discrete: Swift::Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(start.ordinal.rawValue)
        hasher.combine(end.ordinal.rawValue)
    }
}

extension Interval.Discrete where Position: Comparable {

    public init(_ range: Swift::Range<Position>) throws(Error) {
        try self.init(start: range.lowerBound, end: range.upperBound)
    }

    public var range: Swift::Range<Position> {
        precondition(
            start <= end,
            "Position Comparable order must agree with its ordinal order"
        )
        return start..<end
    }
}

extension Interval.Discrete {
    public var count: Position.Count {
        Position.Count(
            Cardinal(
                Subtraction.reporting(end.ordinal.rawValue, start.ordinal.rawValue).value
            )
        )
    }

    public var isEmpty: Bool {
        start.ordinal.rawValue == end.ordinal.rawValue
    }

    public func contains(_ position: Position) -> Bool {
        let value = position.ordinal.rawValue
        return value >= start.ordinal.rawValue && value < end.ordinal.rawValue
    }

    public func translated(
        by offset: consuming Position.Offset
    ) throws(Ordinal.Error) -> Self {
        let translatedStart = try start + offset
        let span = Subtraction.reporting(end.ordinal.rawValue, start.ordinal.rawValue).value
        let translatedEnd: UInt
        do {
            translatedEnd = try Advancement.exact(
                translatedStart.ordinal.rawValue,
                by: span
            )
        } catch {
            throw .overflow
        }

        return Self(
            validatedStart: translatedStart,
            end: Position(Ordinal(translatedEnd))
        )
    }
}
