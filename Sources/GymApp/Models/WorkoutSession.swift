import Foundation
import SwiftData

@Model
final class WorkoutSession {
    var id: UUID
    var date: Date
    var notes: String?
    var isCompleted: Bool

    var day: WorkoutDay?

    @Relationship(deleteRule: .cascade, inverse: \SetEntry.session)
    var setEntries: [SetEntry]? = []

    init(date: Date = .now, day: WorkoutDay?, notes: String? = nil) {
        self.id = UUID()
        self.date = date
        self.day = day
        self.notes = notes
        self.isCompleted = false
    }

    var orderedSetEntries: [SetEntry] {
        (setEntries ?? []).sorted { $0.date < $1.date }
    }
}
