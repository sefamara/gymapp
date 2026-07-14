import SwiftUI

struct CategoryBadge: View {
    let category: ExerciseCategory

    var body: some View {
        Label(category.displayName, systemImage: category.symbolName)
            .font(.caption.weight(.semibold))
            .foregroundStyle(category.tint)
            .padding(.horizontal, Theme.Spacing.sm)
            .padding(.vertical, Theme.Spacing.xs)
            .glassEffect(Glass.regular.tint(category.tint.opacity(0.25)), in: .capsule)
    }
}
