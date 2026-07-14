import SwiftUI
import SwiftData

struct ProgressOverviewView: View {
    @Query(sort: \Exercise.name) private var exercises: [Exercise]

    private var trackedExercises: [Exercise] {
        exercises.filter { !($0.setEntries ?? []).isEmpty }
    }

    var body: some View {
        NavigationStack {
            Group {
                if trackedExercises.isEmpty {
                    ContentUnavailableView(
                        "Todavía sin datos",
                        systemImage: "chart.line.uptrend.xyaxis",
                        description: Text("Registra series en la pestaña Entrenar para ver tu progreso aquí.")
                    )
                } else {
                    ScrollView {
                        GlassEffectContainer(spacing: Theme.Spacing.md) {
                            LazyVStack(spacing: Theme.Spacing.md) {
                                ForEach(trackedExercises) { exercise in
                                    NavigationLink(value: exercise) {
                                        ExerciseProgressSummaryRow(exercise: exercise)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(Theme.Spacing.md)
                        }
                    }
                }
            }
            .navigationTitle("Progreso")
            .navigationDestination(for: Exercise.self) { exercise in
                ExerciseHistoryChart(exercise: exercise)
            }
        }
    }
}

private struct ExerciseProgressSummaryRow: View {
    let exercise: Exercise

    private var bestSet: SetEntry? {
        (exercise.setEntries ?? []).max { $0.estimatedOneRepMax < $1.estimatedOneRepMax }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(exercise.name).font(.headline)
                if let best = bestSet {
                    Text("PR estimado: \(best.estimatedOneRepMax, format: .number.precision(.fractionLength(1))) kg 1RM")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(.tertiary)
        }
        .glassCardStyle()
    }
}

#Preview {
    ProgressOverviewView()
        .modelContainer(PreviewData.container)
}
