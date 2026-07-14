import Foundation
import SwiftData

@Model
final class Exercise {
    var id: UUID
    var name: String
    var categoryRaw: String
    var muscleGroup: String
    var notes: String?
    var isCustom: Bool
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \DayExerciseSlot.exercise)
    var slots: [DayExerciseSlot]? = []

    @Relationship(deleteRule: .cascade, inverse: \SetEntry.exercise)
    var setEntries: [SetEntry]? = []

    var category: ExerciseCategory {
        get { ExerciseCategory(rawValue: categoryRaw) ?? .freeWeight }
        set { categoryRaw = newValue.rawValue }
    }

    init(
        name: String,
        category: ExerciseCategory,
        muscleGroup: String,
        notes: String? = nil,
        isCustom: Bool = true
    ) {
        self.id = UUID()
        self.name = name
        self.categoryRaw = category.rawValue
        self.muscleGroup = muscleGroup
        self.notes = notes
        self.isCustom = isCustom
        self.createdAt = .now
    }
}
