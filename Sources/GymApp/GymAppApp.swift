import SwiftUI
import SwiftData

@main
struct GymAppApp: App {
    let modelContainer: ModelContainer

    init() {
        let schema = Schema([
            Exercise.self,
            WorkoutDay.self,
            DayExerciseSlot.self,
            WorkoutSession.self,
            SetEntry.self,
        ])

        // Requires the iCloud capability + a matching CloudKit container to be
        // enabled in Signing & Capabilities (see GymApp.entitlements). If you
        // don't have an Apple Developer account configured yet, set
        // `cloudKitDatabase: .none` below to run fully local.
        let configuration = ModelConfiguration(schema: schema, cloudKitDatabase: .automatic)

        do {
            modelContainer = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("No se pudo crear el ModelContainer: \(error)")
        }

        SeedData.seedIfNeeded(context: modelContainer.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(modelContainer)
    }
}
