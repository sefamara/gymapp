import SwiftUI

struct SetRowView: View {
    @Bindable var set: SetEntry

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Text("Serie \(set.setNumber)")
                .font(.subheadline.weight(.semibold))
                .frame(width: 64, alignment: .leading)

            HStack(spacing: Theme.Spacing.xs) {
                TextField("Reps", value: $set.reps, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 44)
                Text("reps")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: Theme.Spacing.xs) {
                TextField("Peso", value: $set.weight, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 56)
                Text("kg")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, Theme.Spacing.xs)
        .padding(.horizontal, Theme.Spacing.sm)
        .glassEffect(Glass.regular, in: .rect(cornerRadius: Theme.Radius.control))
    }
}
