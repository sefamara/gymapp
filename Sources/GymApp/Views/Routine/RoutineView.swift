import SwiftUI
import SwiftData

struct RoutineView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \WorkoutDay.order) private var days: [WorkoutDay]

    @State private var isAddingDay = false

    var body: some View {
        NavigationStack {
            ScrollView {
                GlassEffectContainer(spacing: Theme.Spacing.md) {
                    LazyVStack(spacing: Theme.Spacing.md) {
                        ForEach(days) { day in
                            NavigationLink(value: day) {
                                DayRow(day: day)
                                    .contextMenu {
                                        Button("Eliminar día", role: .destructive) {
                                            delete(day)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(Theme.Spacing.md)
                }
            }
            .navigationTitle("Mi rutina")
            .navigationDestination(for: WorkoutDay.self) { day in
                DayDetailView(day: day)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isAddingDay = true
                    } label: {
                        Label("Agregar día", systemImage: "plus")
                    }
                    .buttonStyle(.glassProminent)
                }
            }
            .sheet(isPresented: $isAddingDay) {
                AddDayView(nextOrder: days.count)
            }
            .overlay {
                if days.isEmpty {
                    ContentUnavailableView(
                        "Sin días todavía",
                        systemImage: "calendar.badge.plus",
                        description: Text("Agrega tu primer día de rutina, por ejemplo Push, Pull o Upper.")
                    )
                }
            }
        }
    }

    private func delete(_ day: WorkoutDay) {
        context.delete(day)
    }
}

private struct DayRow: View {
    let day: WorkoutDay

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Image(systemName: day.symbolName)
                .font(.title2)
                .frame(width: 44, height: 44)
                .glassEffect(Glass.regular.tint(.accentColor.opacity(0.3)), in: .circle)

            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(day.name)
                    .font(.headline)
                Text("\(day.orderedSlots.count) ejercicios")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
        }
        .glassCardStyle()
    }
}

#Preview {
    RoutineView()
        .modelContainer(PreviewData.container)
}
