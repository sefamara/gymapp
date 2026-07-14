import SwiftUI
import SwiftData

/// Presented as a sheet from a day's detail view. Calling `onPick` inserts the
/// exercise into that day; this view itself never touches `DayExerciseSlot`.
struct ExercisePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Exercise.name) private var exercises: [Exercise]

    let onPick: (Exercise) -> Void

    @State private var category: ExerciseCategory = .freeWeight
    @State private var searchText = ""
    @State private var isAddingExercise = false

    private var filtered: [Exercise] {
        exercises.filter { $0.category == category }
            .filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.Spacing.md) {
                Picker("Categoría", selection: $category) {
                    ForEach(ExerciseCategory.allCases) { category in
                        Text(category.displayName).tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List {
                    ForEach(filtered) { exercise in
                        Button {
                            onPick(exercise)
                            dismiss()
                        } label: {
                            ExerciseRow(exercise: exercise)
                        }
                    }
                }
                .listStyle(.plain)
                .overlay {
                    if filtered.isEmpty {
                        ContentUnavailableView.search
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Buscar ejercicio")
            .navigationTitle("Elegir ejercicio")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isAddingExercise = true
                    } label: {
                        Label("Nuevo", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingExercise) {
                AddExerciseView(defaultCategory: category)
            }
        }
    }
}

#Preview {
    ExercisePickerView { _ in }
        .modelContainer(PreviewData.container)
}
