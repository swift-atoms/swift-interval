extension Interval.Unit: Swift.ExpressibleByIntegerLiteral
where Scalar: Swift.ExpressibleByIntegerLiteral {

    public typealias IntegerLiteralType = Scalar.IntegerLiteralType

    @inlinable
    public init(integerLiteral value: IntegerLiteralType) {
        let scalar = Scalar(integerLiteral: value)
        precondition(
            scalar >= 0 && scalar <= 1,
            "Integer literal must be 0 or 1"
        )

        self._storage = scalar
    }
}
