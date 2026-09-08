internal import Advancement
internal import Cardinal
internal import Carrier
internal import Distance
import Ordinal

extension Interval.Discrete: Swift.Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(start.ordinal.rawValue)
        hasher.combine(end.ordinal.rawValue)
    }
}
