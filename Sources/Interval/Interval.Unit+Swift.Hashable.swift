extension Interval.Unit: Swift.Hashable {

    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(_storage)
    }
}
