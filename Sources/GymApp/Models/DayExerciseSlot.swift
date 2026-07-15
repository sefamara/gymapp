import Foundation
import SwiftData

@Model
final class DayExerciseSlot {
    var id: UUID
    var order: Int
    var targetSets: Int
    var targetRepsLow: Int
    var targetRepsHigh: Int
    var restSeconds: Int

    var exercise: Exercise?
    var day: WorkoutDay?

    init(
        exercise: Exercise,
        order: Int,
        targetSets: Int = 3,
        targetRepsLow: Int = 8,
        targetRepsHigh: Int = 12,
        restSeconds: Int = 180
    ) {
        self.id = UUID()
        self.exercise = exercise
        self.order = order
        self.targetSets = targetSets
        self.targetRepsLow = targetRepsLow
        self.targetRepsHigh = targetRepsHigh
        self.restSeconds = restSeconds
    }

    var repRangeLabel: String {
        targetRepsLow == targetRepsHigh
            ? "\(targetRepsLow) reps"
            : "\(targetRepsLow)-\(targetRepsHigh) reps"
    }

    var restLabel: String {
        let minutes = restSeconds / 60
        let seconds = restSeconds % 60
        return seconds == 0 ? "\(minutes) min" : "\(minutes)m \(seconds)s"
    }
}
