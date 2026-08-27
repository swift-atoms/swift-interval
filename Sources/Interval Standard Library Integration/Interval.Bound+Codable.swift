import Interval

#if !hasFeature(Embedded)
    extension Interval.Bound: Codable {

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)
            switch value {
            case "lower": self = .lower
            case "upper": self = .upper

            default:
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Expected 'lower' or 'upper', got '\(value)'"
                )
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .lower: try container.encode("lower")
            case .upper: try container.encode("upper")
            }
        }
    }
#endif
