internal import Advancement
internal import Cardinal
internal import Carrier
internal import Distance
public import Ordinal

extension Interval {

    /// A finite, half-open sequence of consecutive positions.
    public struct Discrete<Position: Ordinal.`Protocol`> {

        public let start: Position

        /// The exclusive endpoint.
        public let end: Position

        /// The number of positions, carrying the position's domain.
        public var count: Position.Count {
            Position.Count(
                Cardinal(
                    Distance.reporting(
                        from: start.ordinal.rawValue,
                        to: end.ordinal.rawValue
                    ).value
                )
            )
        }

        public enum Error: Swift.Error, Hashable, Sendable {
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
            let span = Distance.reporting(
                from: start.ordinal.rawValue,
                to: end.ordinal.rawValue
            ).value
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

        private init(validatedStart start: Position, end: Position) {
            self.start = start
            self.end = end
        }
    }
}

extension Interval.Discrete: Swift.Sendable where Position: Swift.Sendable {}

extension Interval.Discrete where Position: Comparable {

    /// Creates an interval from a range whose `Comparable` order agrees with
    /// the position's ordinal order.
    public init(_ range: Swift.Range<Position>) throws(Error) {
        try self.init(start: range.lowerBound, end: range.upperBound)
    }

    /// Returns the equivalent range.
    ///
    /// `Position` must order values in the same direction as `ordinal`.
    public var range: Swift.Range<Position> {
        precondition(
            start <= end,
            "Position Comparable order must agree with its ordinal order"
        )
        return start..<end
    }
}
