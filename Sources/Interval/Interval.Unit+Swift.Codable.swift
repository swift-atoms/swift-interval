#if !hasFeature(Embedded)
extension Interval.Unit: Swift.Codable where Scalar: Swift.Codable {

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(Scalar.self)
            guard let unit = Self(value) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "Value \(value) out of bounds for Interval.Unit (expected [0, 1])"
                    )
                )
            }
            self = unit
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(_storage)
        }
    }
#endif
