import SwiftUI

enum ExerciseCategory: String, Codable, CaseIterable, Identifiable {
    case freeWeight
    case machine
    case cable

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .freeWeight: "Peso libre"
        case .machine: "Máquina"
        case .cable: "Poleas"
        }
    }

    var symbolName: String {
        switch self {
        case .freeWeight: "dumbbell.fill"
        case .machine: "gearshape.2.fill"
        case .cable: "cable.connector"
        }
    }

    var tint: Color {
        switch self {
        case .freeWeight: .orange
        case .machine: .blue
        case .cable: .purple
        }
    }
}
