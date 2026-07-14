import SwiftUI
import SwiftData

struct ActiveWorkoutView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Bindable var session: WorkoutSession

    var body: some View {
        NavigationStack {
            ScrollView {
                GlassEffectContainer(spacing: Theme.Spacing.lg) {
                    LazyVStack(spacing: Theme.Spacing.lg) {
                        ForEach(session.day?.orderedSlots ?? []) { slot in
                            if let exercise = slot.exercise {
                                ExerciseLogSection(session: session, exercise: exercise, slot: slot)
                            }
                        }
                    }
                    .padding(Theme.Spacing.md)
                }
            }
            .navigationTitle(session.day?.name ?? "Entrenamiento")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar", role: .destructive) {
                        context.delete(session)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Terminar") {
                        session.isCompleted = true
                        dismiss()
                    }
                    .buttonStyle(.glassProminent)
                }
            }
        }
    }
}

private struct ExerciseLogSection: View {
    @Environment(\.modelContext) private var context
    @Bindable var session: WorkoutSession
    let exercise: Exercise
    let slot: DayExerciseSlot

    private var loggedSets: [SetEntry] {
        (session.setEntries ?? [])
            .filter { $0.exercise?.id == exercise.id }
            .sorted { $0.setNumber < $1.setNumber }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text(exercise.name).font(.headline)
                    Text("Objetivo: \(slot.targetSets) x \(slot.repRangeLabel)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                CategoryBadge(category: exercise.category)
            }

            ForEach(loggedSets) { set in
                SetRowView(set: set)
            }

            Button {
                addSet()
            } label: {
                Label("Agregar serie", systemImage: "plus.circle.fill")
            }
            .font(.subheadline)
        }
        .glassCardStyle()
    }

    private func addSet() {
        let lastWeight = loggedSets.last?.weight ?? (exercise.setEntries ?? []).sorted { $0.date > $1.date }.first?.weight ?? 0
        let lastReps = loggedSets.last?.reps ?? slot.targetRepsLow
        let newSet = SetEntry(exercise: exercise, setNumber: loggedSets.count + 1, reps: lastReps, weight: lastWeight)
        newSet.session = session
        context.insert(newSet)
    }
}

#Preview {
    let session = WorkoutSession(day: nil)
    return ActiveWorkoutView(session: session)
        .modelContainer(PreviewData.container)
}
