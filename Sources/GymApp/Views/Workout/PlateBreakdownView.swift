import SwiftUI

struct PlateBreakdownView: View {
    let totalWeight: Double

    private var breakdown: PlateCalculator.Breakdown {
        PlateCalculator.breakdown(totalWeight: totalWeight)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("\(totalWeight, format: .number.precision(.fractionLength(0...1))) kg total")
                .font(.headline)
            Text("Barra \(PlateCalculator.defaultBarbellWeightKG, format: .number.precision(.fractionLength(0))) kg + por lado")
                .font(.caption)
                .foregroundStyle(.secondary)

            if breakdown.platesPerSide.isEmpty {
                Text("Solo la barra, sin discos")
                    .font(.subheadline)
            } else {
                HStack(spacing: Theme.Spacing.xs) {
                    ForEach(Array(breakdown.platesPerSide.enumerated()), id: \.offset) { _, plate in
                        PlateChip(weight: plate)
                    }
                }
            }

            if breakdown.remainderPerSide > 0.01 {
                Text("No es exacto — sobran \(breakdown.remainderPerSide, format: .number.precision(.fractionLength(0...2))) kg por lado")
                    .font(.caption2)
                    .foregroundStyle(.orange)
            }
        }
        .padding(Theme.Spacing.md)
        .frame(minWidth: 220)
    }
}

private struct PlateChip: View {
    let weight: Double

    private var color: Color {
        switch weight {
        case 25: .red
        case 20: .blue
        case 15: .yellow
        case 10: .green
        case 5: .white
        case 2.5: .black
        case 1.25: .gray
        default: .gray
        }
    }

    private var textColor: Color {
        color == .white || color == .yellow ? .black : .white
    }

    var body: some View {
        Text(weight, format: .number.precision(.fractionLength(0...2)))
            .font(.caption2.bold())
            .frame(width: 34, height: 34)
            .background(color)
            .foregroundStyle(textColor)
            .clipShape(Circle())
            .overlay(Circle().strokeBorder(.secondary.opacity(0.3)))
    }
}
