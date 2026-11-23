internal import Advancement
internal import Cardinal
internal import Carrier
public import Ordinal
internal import Subtraction

extension Swift::Range where Bound: Ordinal.`Protocol` {

    public init(_ interval: Interval.Discrete<Bound>) {
        precondition(
            interval.start <= interval.end,
            "Position Comparable order must agree with its ordinal order"
        )
        self = interval.start..<interval.end
    }
}
