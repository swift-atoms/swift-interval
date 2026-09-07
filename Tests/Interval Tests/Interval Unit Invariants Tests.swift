import Foundation
import Interval
import Testing

@Suite
struct `Unit interval construction preserves its finite bounds` {
    @Test(arguments: [-Double.infinity, -1, -Double.leastNonzeroMagnitude, Double(1).nextUp, Double.infinity, Double.nan].map(\.bitPattern))
    func `Unchecked construction rejects values outside its precondition`(bits: UInt64) async {
        await #expect(processExitsWith: .failure) { [bits = bits as UInt64] in
            let value = Double(bitPattern: bits)
            let unit = Interval.Unit<Double>(_unchecked: (), value)
            _ = unit.underlying
        }
    }

    @Test(arguments: [-Double.infinity, -1, -Double.leastNonzeroMagnitude, Double(1).nextUp, Double.infinity, Double.nan].map(\.bitPattern))
    func `Float literal construction rejects invalid values instead of clamping`(bits: UInt64) async {
        await #expect(processExitsWith: .failure) { [bits = bits as UInt64] in
            let value = Double(bitPattern: bits)
            let unit = Interval.Unit<Double>(floatLiteral: value)
            _ = unit.underlying
        }
    }

    @Test(arguments: [Int64(-1), 2, Int64.max])
    func `Integer literal construction rejects values other than zero and one`(value: Int64) async {
        await #expect(processExitsWith: .failure) { [value = value as Int64] in
            let unit = Interval.Unit<Double>(integerLiteral: value)
            _ = unit.underlying
        }
    }

    @Test
    func `Every binary sixteen value follows the same checked and clamping contracts`() {
        var violations: [UInt16] = []
        for bits in UInt16.min...UInt16.max {
            let scalar = Float16(bitPattern: bits)
            let accepted = scalar.isFinite && scalar >= 0 && scalar <= 1
            let checked = Interval.Unit<Float16>(scalar)
            let clamped = Interval.Unit<Float16>(clamping: scalar).underlying
            if (checked != nil) != accepted || !clamped.isFinite || clamped < 0 || clamped > 1 {
                violations.append(bits)
            } else if accepted && (checked!.underlying.bitPattern != bits || clamped != scalar) {
                violations.append(bits)
            } else if scalar.isNaN && clamped != 0 {
                violations.append(bits)
            } else if scalar < 0 && clamped != 0 {
                violations.append(bits)
            } else if scalar > 1 && clamped != 1 {
                violations.append(bits)
            }
        }
        #expect(violations.isEmpty)
    }

    @Test
    func `Every valid binary sixteen value remains bounded under interval operations`() {
        var violations: [UInt16] = []
        for bits in UInt16.min...UInt16.max {
            guard let unit = Interval.Unit<Float16>(Float16(bitPattern: bits)) else { continue }
            let results = [
                unit.complement,
                unit * unit,
                unit * .zero,
                unit * .one,
                unit.interpolated(to: .zero, at: .half),
                unit.interpolated(to: .one, at: .half),
            ]
            if results.contains(where: { !$0.underlying.isFinite || $0.underlying < 0 || $0.underlying > 1 })
                || unit * .one != unit
                || unit * .zero != .zero
                || unit.interpolated(to: .one, at: .zero) != unit
                || unit.interpolated(to: .zero, at: .one) != .zero {
                violations.append(bits)
            }
        }
        #expect(violations.isEmpty)
    }

    @Test
    func `Complement follows rounded subtraction without promising an exact involution`() throws {
        let unit = try #require(Interval.Unit<Double>(Double.leastNonzeroMagnitude))
        #expect(unit.complement == .one)
        #expect(unit.complement.complement == .zero)
        #expect(unit != .zero)
    }

    @Test(arguments: [-0.0, 0.0, Double.leastNonzeroMagnitude, 0.25, 0.5, Double(1).nextDown, 1.0])
    func `Valid construction and single value coding preserve scalar values`(scalar: Double) throws {
        let checked = try #require(Interval.Unit<Double>(scalar))
        #expect(Interval.Unit<Double>(_unchecked: (), scalar) == checked)
        #expect(Interval.Unit<Double>(floatLiteral: scalar) == checked)
        let encoded = try JSONEncoder().encode(checked)
        #expect(try JSONDecoder().decode(Double.self, from: encoded) == scalar)
        #expect(try JSONDecoder().decode(Interval.Unit<Double>.self, from: encoded) == checked)
    }

    @Test(arguments: [-1.0, -Double.leastNonzeroMagnitude, Double(1).nextUp, 2.0])
    func `Decoding rejects finite values outside the interval`(value: Double) throws {
        let data = try JSONEncoder().encode(value)
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(Interval.Unit<Double>.self, from: data)
        }
    }

    @Test(arguments: ["NaN", "Infinity", "-Infinity"])
    func `Decoding rejects nonfinite values even when scalar decoding allows them`(value: String) throws {
        let decoder = JSONDecoder()
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(
            positiveInfinity: "Infinity", negativeInfinity: "-Infinity", nan: "NaN"
        )
        let data = try JSONEncoder().encode(value)
        #expect(throws: DecodingError.self) {
            try decoder.decode(Interval.Unit<Double>.self, from: data)
        }
    }
}
