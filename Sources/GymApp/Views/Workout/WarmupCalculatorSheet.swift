import SwiftUI

struct WarmupCalculatorSheet: View {
    @Environment(\.dismiss) private var dismiss
    let exercise: Exercise
    @State private var workWeight: Double

    init(exercise: Exercise, suggestedWeight: Double) {
        self.exercise = exercise
        _workWeight = State(initialValue: suggestedWeight)
    }

    private var warmupSets: [WarmupCalculator.WarmupSet] {
        WarmupCalculator.suggestedSets(workWeight: workWeight)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Peso de trabajo") {
                    HStack {
                        TextField("Peso", value: $workWeight, format: .number)
                            .keyboardType(.decimalPad)
                        Text("kg")
                            .foregroundStyle(.secondary)
                    }
                }
                Section("Calentamiento sugerido") {
                    ForEach(warmupSets) { warmupSet in
                        WarmupRow(warmupSet: warmupSet)
                    }
                }
            }
            .navigationTitle("Calentamiento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }
                }
            }
        }
    }
}

private struct WarmupRow: View {
    let warmupSet: WarmupCalculator.WarmupSet

    var body: some View {
        HStack {
            Text("\(Int(warmupSet.percentage * 100))%")
                .foregroundStyle(.secondary)
                .frame(width: 48, alignment: .leading)
            Text(warmupSet.weight, format: .number.precision(.fractionLength(0...1)))
                .font(.headline)
            Text("kg")
                .foregroundStyle(.secondary)
            Spacer()
            Text("\(warmupSet.reps) reps")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    WarmupCalculatorSheet(exercise: Exercise(name: "Press banca", category: .freeWeight, muscleGroup: "Pecho"), suggestedWeight: 60)
}
