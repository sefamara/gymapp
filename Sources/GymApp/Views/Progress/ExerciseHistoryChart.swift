import SwiftUI
import Charts

struct ExerciseHistoryChart: View {
    let exercise: Exercise

    /// Best estimated 1RM per calendar day, so multiple sets in one session
    /// collapse into a single point instead of crowding the chart.
    private var dailyBests: [(date: Date, oneRepMax: Double)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: exercise.setEntries ?? []) { entry in
            calendar.startOfDay(for: entry.date)
        }
        return grouped
            .map { day, entries in (date: day, oneRepMax: entries.map(\.estimatedOneRepMax).max() ?? 0) }
            .sorted { $0.date < $1.date }
    }

    private var recentEntries: [SetEntry] {
        Array((exercise.setEntries ?? []).sorted { $0.date > $1.date }.prefix(30))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text("1RM estimado (Epley)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Chart(dailyBests, id: \.date) { point in
                        LineMark(x: .value("Fecha", point.date), y: .value("1RM", point.oneRepMax))
                            .interpolationMethod(.catmullRom)
                        PointMark(x: .value("Fecha", point.date), y: .value("1RM", point.oneRepMax))
                    }
                    .foregroundStyle(exercise.category.tint)
                    .frame(height: 240)
                }
                .glassCardStyle()

                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text("Historial de series")
                        .font(.headline)

                    ForEach(recentEntries) { entry in
                        SetHistoryRow(entry: entry)
                    }
                }
                .glassCardStyle()
            }
            .padding(Theme.Spacing.md)
        }
        .navigationTitle(exercise.name)
    }
}

private struct SetHistoryRow: View {
    let entry: SetEntry

    var body: some View {
        HStack {
            Text(entry.date, format: .dateTime.day().month().year())
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Text("\(entry.reps) reps × \(entry.weight, format: .number.precision(.fractionLength(1))) kg")
                .font(.subheadline)
        }
        .padding(.vertical, Theme.Spacing.xs)
    }
}
