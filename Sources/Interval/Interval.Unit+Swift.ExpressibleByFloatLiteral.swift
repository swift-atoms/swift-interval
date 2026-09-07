extension Interval.Unit: Swift.ExpressibleByFloatLiteral
where Scalar: Swift.ExpressibleByFloatLiteral {

    public typealias FloatLiteralType = Scalar.FloatLiteralType

    @inlinable
    public init(floatLiteral value: FloatLiteralType) {
        let scalar = Scalar(floatLiteral: value)
        precondition(
            scalar.isFinite && scalar >= 0 && scalar <= 1,
            "Float literal must be finite and in [0, 1]"
        )

        self._storage = scalar
    }
}
