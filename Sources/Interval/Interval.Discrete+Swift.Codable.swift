internal import Advancement
internal import Cardinal
internal import Carrier
internal import Distance
public import Ordinal

#if !hasFeature(Embedded)
extension Interval.Discrete: Swift.Codable where Position: Swift.Codable {

        private enum CodingKeys: String, CodingKey {
            case start
            case end
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let start = try container.decode(Position.self, forKey: .start)
            let end = try container.decode(Position.self, forKey: .end)

            do {
                try self.init(start: start, end: end)
            } catch {
                throw DecodingError.dataCorruptedError(
                    forKey: .end,
                    in: container,
                    debugDescription: "Interval.Discrete end precedes its start"
                )
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(start, forKey: .start)
            try container.encode(end, forKey: .end)
        }
    }
#endif
