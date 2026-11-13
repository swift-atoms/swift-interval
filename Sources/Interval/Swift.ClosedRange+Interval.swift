extension Swift::ClosedRange where Bound: BinaryFloatingPoint {

    /// How far `value` has come through the range: 0 at the lower bound, 1 at the upper, and linear in
    /// between and beyond, so a value below the range gives a negative progress and one above it more
    /// than 1. A range of one point is a step: 0 below the point, 1 at it and above.
    @inlinable
    public func progress(of value: Bound) -> Bound {
        guard lowerBound < upperBound else { return value < lowerBound ? 0 : 1 }
        return (value - lowerBound) / (upperBound - lowerBound)
    }
}
