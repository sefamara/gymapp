import SwiftUI

/// Shared row used by the exercise picker and the exercise library. Kept as
/// its own small view so SwiftUI's type-checker doesn't have to resolve it
/// inline inside a `ForEach` alongside a `Button`/`List` container.
struct ExerciseRow: View {
    let exercise: Exercise
    var trailing: String?

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(exercise.name)
                Text(exercise.muscleGroup)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if let trailing {
                Text(trailing)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
    }
}
