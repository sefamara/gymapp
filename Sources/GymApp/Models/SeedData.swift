import Foundation
import SwiftData

/// Populates a fresh database with a common exercise library and an editable
/// Push/Pull/Legs/Upper/Lower day structure, so the app is usable immediately
/// instead of starting from a blank slate.
enum SeedData {

    static func seedIfNeeded(context: ModelContext) {
        let existing = try? context.fetch(FetchDescriptor<Exercise>())
        guard (existing?.isEmpty ?? true) else { return }

        let exercises = seedExercises(context: context)
        seedDays(context: context, exercises: exercises)

        try? context.save()
    }

    @discardableResult
    private static func seedExercises(context: ModelContext) -> [String: Exercise] {
        let definitions: [(String, ExerciseCategory, String)] = [
            // Peso libre
            ("Press banca con barra", .freeWeight, "Pecho"),
            ("Press militar con barra", .freeWeight, "Hombros"),
            ("Sentadilla con barra", .freeWeight, "Piernas"),
            ("Peso muerto", .freeWeight, "Espalda"),
            ("Remo con barra", .freeWeight, "Espalda"),
            ("Press inclinado con mancuernas", .freeWeight, "Pecho"),
            ("Curl de bíceps con mancuernas", .freeWeight, "Brazos"),
            ("Zancadas con mancuernas", .freeWeight, "Piernas"),
            ("Elevaciones laterales", .freeWeight, "Hombros"),
            ("Press francés con barra Z", .freeWeight, "Brazos"),
            ("Hip thrust con barra", .freeWeight, "Piernas"),
            ("Dominadas", .freeWeight, "Espalda"),

            // Máquina
            ("Prensa de piernas", .machine, "Piernas"),
            ("Press de pecho en máquina", .machine, "Pecho"),
            ("Jalón al pecho", .machine, "Espalda"),
            ("Remo en máquina", .machine, "Espalda"),
            ("Extensión de cuádriceps", .machine, "Piernas"),
            ("Curl femoral en máquina", .machine, "Piernas"),
            ("Press de hombro en máquina", .machine, "Hombros"),
            ("Máquina abductor/aductor", .machine, "Piernas"),

            // Poleas
            ("Jalón de tríceps en polea", .cable, "Brazos"),
            ("Curl de bíceps en polea", .cable, "Brazos"),
            ("Cruce de poleas (pec deck cable)", .cable, "Pecho"),
            ("Face pull en polea", .cable, "Hombros"),
            ("Remo sentado en polea", .cable, "Espalda"),
            ("Pull-over en polea", .cable, "Espalda"),
            ("Patada de tríceps en polea", .cable, "Brazos"),
            ("Elevaciones laterales en polea", .cable, "Hombros"),
        ]

        var byName: [String: Exercise] = [:]
        for (name, category, muscle) in definitions {
            let exercise = Exercise(name: name, category: category, muscleGroup: muscle, isCustom: false)
            context.insert(exercise)
            byName[name] = exercise
        }
        return byName
    }

    private static func seedDays(context: ModelContext, exercises: [String: Exercise]) {
        func slot(_ name: String, sets: Int, low: Int, high: Int, order: Int) -> DayExerciseSlot? {
            guard let exercise = exercises[name] else { return nil }
            return DayExerciseSlot(exercise: exercise, order: order, targetSets: sets, targetRepsLow: low, targetRepsHigh: high)
        }

        let dayPlans: [(name: String, symbol: String, slots: [(String, Int, Int, Int)])] = [
            ("Push", "arrow.up.circle.fill", [
                ("Press banca con barra", 4, 6, 10),
                ("Press inclinado con mancuernas", 3, 8, 12),
                ("Press de hombro en máquina", 3, 8, 12),
                ("Elevaciones laterales", 3, 12, 15),
                ("Jalón de tríceps en polea", 3, 10, 15),
            ]),
            ("Pull", "arrow.down.circle.fill", [
                ("Peso muerto", 3, 5, 8),
                ("Dominadas", 4, 6, 10),
                ("Remo con barra", 3, 8, 12),
                ("Jalón al pecho", 3, 10, 12),
                ("Curl de bíceps en polea", 3, 10, 15),
            ]),
            ("Legs", "figure.strengthtraining.traditional", [
                ("Sentadilla con barra", 4, 5, 8),
                ("Prensa de piernas", 3, 8, 12),
                ("Curl femoral en máquina", 3, 10, 15),
                ("Hip thrust con barra", 3, 8, 12),
                ("Extensión de cuádriceps", 3, 12, 15),
            ]),
            ("Upper", "figure.arms.open", [
                ("Press banca con barra", 3, 6, 10),
                ("Remo en máquina", 3, 8, 12),
                ("Press de hombro en máquina", 3, 8, 12),
                ("Curl de bíceps con mancuernas", 3, 10, 12),
                ("Patada de tríceps en polea", 3, 10, 15),
            ]),
            ("Lower", "figure.run", [
                ("Sentadilla con barra", 4, 5, 8),
                ("Zancadas con mancuernas", 3, 8, 12),
                ("Curl femoral en máquina", 3, 10, 15),
                ("Máquina abductor/aductor", 3, 12, 15),
            ]),
        ]

        for (index, plan) in dayPlans.enumerated() {
            let day = WorkoutDay(name: plan.name, symbolName: plan.symbol, order: index)
            context.insert(day)
            for (slotIndex, definition) in plan.slots.enumerated() {
                if let newSlot = slot(definition.0, sets: definition.1, low: definition.2, high: definition.3, order: slotIndex) {
                    newSlot.day = day
                    context.insert(newSlot)
                }
            }
        }
    }
}
