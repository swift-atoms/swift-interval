import Interval

#if !hasFeature(Embedded)
    extension Interval.Boundary: Codable {

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)
            switch value {
            case "closed": self = .closed
            case "open": self = .open

            default:
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Expected 'closed' or 'open', got '\(value)'"
                )
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .closed: try container.encode("closed")
            case .open: try container.encode("open")
            }
        }
    }
#endif
