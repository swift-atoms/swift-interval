
extension Interval {

    public struct Unit<Scalar: BinaryFloatingPoint> {

        @usableFromInline internal var _storage: Scalar

        @inlinable
        public init?(_ value: Scalar) {
            guard value.isFinite && value >= 0 && value <= 1 else { return nil }
            self._storage = value
        }

        @inlinable
        public init(
            _unchecked: Void,
            _ value: Scalar
        ) {
            assert(value.isFinite, "Interval.Unit requires finite values")
            assert(value >= 0 && value <= 1, "Interval.Unit requires value in [0, 1]")
            self._storage = value
        }

        @inlinable
        public init(clamping value: Scalar) {
            if value.isNaN {
                self._storage = 0
            } else {
                self._storage = min(max(value, 0), 1)
            }
        }
    }
}

extension Interval.Unit {

    @inlinable
    public var underlying: Scalar { _storage }
}

extension Interval.Unit: Sendable where Scalar: Sendable {}

extension Interval.Unit: Equatable {

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs._storage == rhs._storage
    }
}

extension Interval.Unit: Hashable {

    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(_storage)
    }
}

extension Interval.Unit: Comparable {

    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs._storage < rhs._storage
    }
}

extension Interval.Unit {

    @inlinable
    public static var zero: Self { Self(_unchecked: (), 0) }

    @inlinable
    public static var one: Self { Self(_unchecked: (), 1) }

    @inlinable
    public static var half: Self { Self(_unchecked: (), Scalar(0.5)) }
}

extension Interval.Unit {

    @inlinable
    public var complement: Self {

        Self(_unchecked: (), min(max(1 - _storage, 0), 1))
    }

    @inlinable
    public func interpolated(to other: Self, at t: Self) -> Self {

        let result = _storage * (1 - t._storage) + other._storage * t._storage
        return Self(_unchecked: (), min(max(result, 0), 1))
    }
}

extension Interval.Unit {

    @inlinable
    public static func * (lhs: Self, rhs: Self) -> Self {

        Self(_unchecked: (), min(max(lhs._storage * rhs._storage, 0), 1))
    }

    @inlinable
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
}

extension Interval.Unit: ExpressibleByFloatLiteral
where Scalar: ExpressibleByFloatLiteral {

    public typealias FloatLiteralType = Scalar.FloatLiteralType

    @inlinable
    public init(floatLiteral value: FloatLiteralType) {
        let scalar = Scalar(floatLiteral: value)
        assert(
            scalar.isFinite && scalar >= 0 && scalar <= 1,
            "Float literal must be finite and in [0, 1]"
        )

        self._storage = scalar.isNaN ? 0 : min(max(scalar, 0), 1)
    }
}

extension Interval.Unit: ExpressibleByIntegerLiteral
where Scalar: ExpressibleByIntegerLiteral {

    public typealias IntegerLiteralType = Scalar.IntegerLiteralType

    @inlinable
    public init(integerLiteral value: IntegerLiteralType) {
        let scalar = Scalar(integerLiteral: value)
        assert(
            scalar >= 0 && scalar <= 1,
            "Integer literal must be 0 or 1"
        )

        self._storage = min(max(scalar, 0), 1)
    }
}

#if !hasFeature(Embedded)
    extension Interval.Unit: Codable where Scalar: Codable {

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(Scalar.self)
            guard let unit = Self(value) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "Value \(value) out of bounds for Interval.Unit (expected [0, 1])"
                    )
                )
            }
            self = unit
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(_storage)
        }
    }
#endif

public typealias Opacity<Scalar: BinaryFloatingPoint> = Interval.Unit<Scalar>

public typealias Alpha<Scalar: BinaryFloatingPoint> = Opacity<Scalar>
