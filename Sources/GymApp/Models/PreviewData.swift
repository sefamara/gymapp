import SwiftData

/// In-memory container with seed data, used only by SwiftUI previews.
enum PreviewData {
    @MainActor
    static let container: ModelContainer = {
        let schema = Schema([Exercise.self, WorkoutDay.self, DayExerciseSlot.self, WorkoutSession.self, SetEntry.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [config])
        SeedData.seedIfNeeded(context: container.mainContext)
        return container
    }()
}
