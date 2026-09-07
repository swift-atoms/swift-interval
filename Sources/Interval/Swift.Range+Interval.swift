internal import Advancement
internal import Cardinal
internal import Carrier
internal import Distance
public import Ordinal

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
