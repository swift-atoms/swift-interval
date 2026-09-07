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

extension Interval.Unit: Swift.Sendable where Scalar: Swift.Sendable {}

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

public typealias Opacity<Scalar: BinaryFloatingPoint> = Interval.Unit<Scalar>

public typealias Alpha<Scalar: BinaryFloatingPoint> = Opacity<Scalar>
