internal import Advancement
internal import Cardinal
internal import Carrier
internal import Distance
public import Ordinal

extension Interval.Discrete: Swift.Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.start.ordinal.rawValue == rhs.start.ordinal.rawValue
            && lhs.end.ordinal.rawValue == rhs.end.ordinal.rawValue
    }
}
