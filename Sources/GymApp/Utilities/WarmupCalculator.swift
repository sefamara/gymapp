import Foundation

/// Generates a standard percentage-based warm-up ramp (40/60/80% of the
/// working weight) leading into the work sets, rounded to a loadable
/// increment.
enum WarmupCalculator {
    struct WarmupSet: Identifiable {
        let id = UUID()
        let percentage: Double
        let weight: Double
        let reps: Int
    }

    private static let steps: [(percentage: Double, reps: Int)] = [
        (0.4, 10),
        (0.6, 5),
        (0.8, 3),
    ]

    static func suggestedSets(workWeight: Double, roundingIncrement: Double = 2.5) -> [WarmupSet] {
        guard workWeight > 0, roundingIncrement > 0 else { return [] }
        return steps.map { step in
            let rawWeight = workWeight * step.percentage
            let rounded = (rawWeight / roundingIncrement).rounded() * roundingIncrement
            return WarmupSet(percentage: step.percentage, weight: rounded, reps: step.reps)
        }
    }
}
