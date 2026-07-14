import SwiftUI
import SwiftData

struct ExerciseLibraryView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Exercise.name) private var exercises: [Exercise]

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
                        HStack {
                            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                                Text(exercise.name)
                                Text(exercise.muscleGroup)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            if !exercise.isCustom {
                                Text("Predefinido")
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)
            }
            .searchable(text: $searchText, prompt: "Buscar ejercicio")
            .navigationTitle("Ejercicios")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isAddingExercise = true
                    } label: {
                        Label("Agregar", systemImage: "plus")
                    }
                    .buttonStyle(.glassProminent)
                }
            }
            .sheet(isPresented: $isAddingExercise) {
                AddExerciseView(defaultCategory: category)
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            context.delete(filtered[index])
        }
    }
}

#Preview {
    ExerciseLibraryView()
        .modelContainer(PreviewData.container)
}
