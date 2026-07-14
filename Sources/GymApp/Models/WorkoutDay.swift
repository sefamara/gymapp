import Foundation
import SwiftData

@Model
final class WorkoutDay {
    var id: UUID
    var name: String
    var symbolName: String
    var order: Int
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \DayExerciseSlot.day)
    var slots: [DayExerciseSlot]? = []

    @Relationship(deleteRule: .nullify, inverse: \WorkoutSession.day)
    var sessions: [WorkoutSession]? = []

    init(name: String, symbolName: String = "flame.fill", order: Int) {
        self.id = UUID()
        self.name = name
        self.symbolName = symbolName
        self.order = order
        self.createdAt = .now
    }

    var orderedSlots: [DayExerciseSlot] {
        (slots ?? []).sorted { $0.order < $1.order }
    }
}
