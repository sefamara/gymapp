import SwiftUI

struct AddDayView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    let nextOrder: Int

    @State private var name = ""
    @State private var symbolName = "flame.fill"

    private let symbolOptions = [
        "flame.fill", "arrow.up.circle.fill", "arrow.down.circle.fill",
        "figure.strengthtraining.traditional", "figure.arms.open", "figure.run",
        "bolt.fill", "star.fill",
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Nombre del día") {
                    TextField("Ej. Push, Pull, Upper...", text: $name)
                }
                Section("Ícono") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: Theme.Spacing.md) {
                        ForEach(symbolOptions, id: \.self) { symbol in
                            SymbolOption(symbol: symbol, isSelected: symbol == symbolName) {
                                symbolName = symbol
                            }
                        }
                    }
                    .padding(.vertical, Theme.Spacing.sm)
                }
            }
            .navigationTitle("Nuevo día")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func save() {
        let day = WorkoutDay(name: name.trimmingCharacters(in: .whitespaces), symbolName: symbolName, order: nextOrder)
        context.insert(day)
        dismiss()
    }
}

private struct SymbolOption: View {
    let symbol: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Image(systemName: symbol)
            .font(.title2)
            .frame(width: 48, height: 48)
            .glassEffect(isSelected ? Glass.regular.tint(.accentColor) : Glass.regular, in: .circle)
            .onTapGesture(perform: onTap)
    }
}

#Preview {
    AddDayView(nextOrder: 0)
        .modelContainer(PreviewData.container)
}
