import Foundation

/// Works out which plates to load per side of a barbell for a given total
/// weight, using a standard commercial gym plate inventory (kg).
enum PlateCalculator {
    static let standardPlatesKG: [Double] = [25, 20, 15, 10, 5, 2.5, 1.25]
    static let defaultBarbellWeightKG: Double = 20

    struct Breakdown {
        let platesPerSide: [Double]
        let remainderPerSide: Double
    }

    static func breakdown(
        totalWeight: Double,
        barbellWeight: Double = defaultBarbellWeightKG,
        availablePlates: [Double] = standardPlatesKG
    ) -> Breakdown {
        var remaining = max((totalWeight - barbellWeight) / 2, 0)
        var plates: [Double] = []

        for plate in availablePlates {
            while remaining + 0.001 >= plate {
                plates.append(plate)
                remaining -= plate
            }
        }

        return Breakdown(platesPerSide: plates, remainderPerSide: max(remaining, 0))
    }
}
