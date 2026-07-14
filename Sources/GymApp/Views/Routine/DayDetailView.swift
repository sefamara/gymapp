import SwiftUI
import SwiftData

struct DayDetailView: View {
    @Environment(\.modelContext) private var context
    @Bindable var day: WorkoutDay

    @State private var isPickingExercise = false

    var body: some View {
        ScrollView {
            GlassEffectContainer(spacing: Theme.Spacing.md) {
                LazyVStack(spacing: Theme.Spacing.md) {
                    ForEach(day.orderedSlots) { slot in
                        SlotRow(slot: slot)
                            .contextMenu {
                                Button("Eliminar ejercicio", role: .destructive) {
                                    context.delete(slot)
                                }
                            }
                    }
                }
                .padding(Theme.Spacing.md)
            }
        }
        .navigationTitle(day.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPickingExercise = true
                } label: {
                    Label("Agregar ejercicio", systemImage: "plus")
                }
                .buttonStyle(.glassProminent)
            }
        }
        .sheet(isPresented: $isPickingExercise) {
            ExercisePickerView { exercise in
                addExercise(exercise)
            }
        }
        .overlay {
            if day.orderedSlots.isEmpty {
                ContentUnavailableView(
                    "Sin ejercicios",
                    systemImage: "dumbbell",
                    description: Text("Agrega ejercicios de peso libre, máquina o poleas a este día.")
                )
            }
        }
    }

    private func addExercise(_ exercise: Exercise) {
        let slot = DayExerciseSlot(exercise: exercise, order: day.orderedSlots.count)
        slot.day = day
        context.insert(slot)
    }
}

private struct SlotRow: View {
    @Bindable var slot: DayExerciseSlot

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text(slot.exercise?.name ?? "Ejercicio eliminado")
                        .font(.headline)
                    if let category = slot.exercise?.category {
                        CategoryBadge(category: category)
                    }
                }
                Spacer()
            }

            HStack {
                Stepper("\(slot.targetSets) series", value: $slot.targetSets, in: 1...10)
                    .font(.subheadline)
            }

            HStack {
                Text("Reps objetivo")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Stepper("\(slot.targetRepsLow)", value: $slot.targetRepsLow, in: 1...50)
                Text("–")
                Stepper("\(slot.targetRepsHigh)", value: $slot.targetRepsHigh, in: 1...50)
            }
            .font(.subheadline)
        }
        .glassCardStyle()
    }
}
