import Foundation
import SwiftData

@Model
final class SetEntry {
    var id: UUID
    var setNumber: Int
    var reps: Int
    var weight: Double
    var rpe: Double?
    var date: Date

    var exercise: Exercise?
    var session: WorkoutSession?

    init(
        exercise: Exercise,
        setNumber: Int,
        reps: Int,
        weight: Double,
        rpe: Double? = nil,
        date: Date = .now
    ) {
        self.id = UUID()
        self.exercise = exercise
        self.setNumber = setNumber
        self.reps = reps
        self.weight = weight
        self.rpe = rpe
        self.date = date
    }

    /// Epley formula estimate, used to compare sets of different rep ranges on the progress chart.
    var estimatedOneRepMax: Double {
        weight * (1 + Double(reps) / 30)
    }
}
