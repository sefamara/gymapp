import SwiftUI

struct AddExerciseView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    let defaultCategory: ExerciseCategory

    @State private var name = ""
    @State private var category: ExerciseCategory
    @State private var muscleGroup = ""

    init(defaultCategory: ExerciseCategory) {
        self.defaultCategory = defaultCategory
        _category = State(initialValue: defaultCategory)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Ejercicio") {
                    TextField("Nombre", text: $name)
                    TextField("Grupo muscular", text: $muscleGroup)
                }
                Section("Categoría") {
                    Picker("Categoría", selection: $category) {
                        ForEach(ExerciseCategory.allCases) { category in
                            Label(category.displayName, systemImage: category.symbolName).tag(category)
                        }
                    }
                    .pickerStyle(.inline)
                }
            }
            .navigationTitle("Nuevo ejercicio")
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
        let exercise = Exercise(
            name: name.trimmingCharacters(in: .whitespaces),
            category: category,
            muscleGroup: muscleGroup.trimmingCharacters(in: .whitespaces)
        )
        context.insert(exercise)
        dismiss()
    }
}

#Preview {
    AddExerciseView(defaultCategory: .freeWeight)
        .modelContainer(PreviewData.container)
}
