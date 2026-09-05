public import Advancement
public import Cardinal
public import Carrier_Protocol
public import Distance
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

extension Interval.Discrete: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.start.ordinal.rawValue == rhs.start.ordinal.rawValue
            && lhs.end.ordinal.rawValue == rhs.end.ordinal.rawValue
    }
}

extension Interval.Discrete: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(start.ordinal.rawValue)
        hasher.combine(end.ordinal.rawValue)
    }
}

extension Interval.Discrete: Sendable where Position: Sendable {}

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

extension Swift.Range where Bound: Ordinal.`Protocol` {

    /// Creates a range when `Bound`'s `Comparable` order agrees with its ordinal order.
    public init(_ interval: Interval.Discrete<Bound>) {
        precondition(
            interval.start <= interval.end,
            "Position Comparable order must agree with its ordinal order"
        )
        self = interval.start..<interval.end
    }
}

#if !hasFeature(Embedded)
    extension Interval.Discrete: Codable where Position: Codable {

        private enum CodingKeys: String, CodingKey {
            case start
            case end
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let start = try container.decode(Position.self, forKey: .start)
            let end = try container.decode(Position.self, forKey: .end)

            do {
                try self.init(start: start, end: end)
            } catch {
                throw DecodingError.dataCorruptedError(
                    forKey: .end,
                    in: container,
                    debugDescription: "Interval.Discrete end precedes its start"
                )
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(start, forKey: .start)
            try container.encode(end, forKey: .end)
        }
    }
#endif
