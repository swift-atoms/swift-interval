import Interval

#if !hasFeature(Embedded)
    extension Interval.Endpoint: Codable {

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)
            switch value {
            case "start": self = .start
            case "end": self = .end

            default:
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Expected 'start' or 'end', got '\(value)'"
                )
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .start: try container.encode("start")
            case .end: try container.encode("end")
            }
        }
    }
#endif
