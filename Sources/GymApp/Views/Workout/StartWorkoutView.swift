import SwiftUI
import SwiftData

struct StartWorkoutView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \WorkoutDay.order) private var days: [WorkoutDay]

    @State private var activeSession: WorkoutSession?

    var body: some View {
        NavigationStack {
            ScrollView {
                GlassEffectContainer(spacing: Theme.Spacing.md) {
                    LazyVStack(spacing: Theme.Spacing.md) {
                        ForEach(days) { day in
                            Button {
                                start(day: day)
                            } label: {
                                HStack(spacing: Theme.Spacing.md) {
                                    Image(systemName: day.symbolName)
                                        .font(.title2)
                                        .frame(width: 44, height: 44)
                                        .glassEffect(Glass.regular.tint(.accentColor.opacity(0.3)), in: .circle)
                                    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                                        Text(day.name).font(.headline)
                                        Text("\(day.orderedSlots.count) ejercicios").font(.subheadline).foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "play.fill").foregroundStyle(.accentColor)
                                }
                                .glassCardStyle()
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(Theme.Spacing.md)
                }
            }
            .navigationTitle("Entrenar")
            .overlay {
                if days.isEmpty {
                    ContentUnavailableView(
                        "Crea un día primero",
                        systemImage: "calendar.badge.plus",
                        description: Text("Ve a la pestaña Rutina para agregar tus días de entrenamiento.")
                    )
                }
            }
            .fullScreenCover(item: $activeSession) { session in
                ActiveWorkoutView(session: session)
            }
        }
    }

    private func start(day: WorkoutDay) {
        let session = WorkoutSession(day: day)
        context.insert(session)
        activeSession = session
    }
}

#Preview {
    StartWorkoutView()
        .modelContainer(PreviewData.container)
}
