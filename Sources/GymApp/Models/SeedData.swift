import Foundation
import SwiftData

/// Populates a fresh database with a common exercise library and an editable
/// Push/Pull/Legs/Upper/Lower day structure, so the app is usable immediately
/// instead of starting from a blank slate.
///
/// Also incrementally migrates existing installs when the library grows —
/// guarded by `routineMigrationKey` so it only ever adds missing exercises
/// and rebuilds the Push/Pull/Legs/Upper/Lower slot lists once, without
/// touching custom days or logged workout history.
enum SeedData {
    private static let routineMigrationKey = "com.gymapp.routineMigration.v2"

    static func seedIfNeeded(context: ModelContext) {
        let existing = try? context.fetch(FetchDescriptor<Exercise>())
        if existing?.isEmpty ?? true {
            let exercises = seedExercises(context: context)
            seedDays(context: context, exercises: exercises)
            try? context.save()
            UserDefaults.standard.set(true, forKey: routineMigrationKey)
        } else {
            migrateRoutineIfNeeded(context: context)
        }
    }

    private static func migrateRoutineIfNeeded(context: ModelContext) {
        guard !UserDefaults.standard.bool(forKey: routineMigrationKey) else { return }

        let existingExercises = (try? context.fetch(FetchDescriptor<Exercise>())) ?? []
        var byName = Dictionary(uniqueKeysWithValues: existingExercises.map { ($0.name, $0) })

        for definition in exerciseDefinitions where byName[definition.name] == nil {
            let exercise = Exercise(name: definition.name, category: definition.category, muscleGroup: definition.muscle, isCustom: false)
            context.insert(exercise)
            byName[definition.name] = exercise
        }

        let existingDays = (try? context.fetch(FetchDescriptor<WorkoutDay>())) ?? []
        var dayByName = Dictionary(uniqueKeysWithValues: existingDays.map { ($0.name, $0) })

        for (index, plan) in dayPlans.enumerated() {
            let day: WorkoutDay
            if let existingDay = dayByName[plan.name] {
                day = existingDay
                for oldSlot in existingDay.orderedSlots {
                    context.delete(oldSlot)
                }
            } else {
                day = WorkoutDay(name: plan.name, symbolName: plan.symbol, order: index)
                context.insert(day)
                dayByName[plan.name] = day
            }
            insertSlots(plan.slots, into: day, exercises: byName, context: context)
        }

        try? context.save()
        UserDefaults.standard.set(true, forKey: routineMigrationKey)
    }

    private static let exerciseDefinitions: [(name: String, category: ExerciseCategory, muscle: String)] = [
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
        ("Curl martillo con mancuernas", .freeWeight, "Brazos"),
        ("Curl predicador con barra Z", .freeWeight, "Brazos"),
        ("Curl de muñeca con barra", .freeWeight, "Antebrazo"),
        ("Curl de muñeca inverso con barra", .freeWeight, "Antebrazo"),

        // Máquina
        ("Prensa de piernas", .machine, "Piernas"),
        ("Press de pecho en máquina", .machine, "Pecho"),
        ("Jalón al pecho", .machine, "Espalda"),
        ("Remo en máquina", .machine, "Espalda"),
        ("Extensión de cuádriceps", .machine, "Piernas"),
        ("Curl femoral en máquina", .machine, "Piernas"),
        ("Press de hombro en máquina", .machine, "Hombros"),
        ("Máquina abductor/aductor", .machine, "Piernas"),
        ("Press banca en máquina", .machine, "Pecho"),
        ("Press inclinado en máquina", .machine, "Pecho"),
        ("Aperturas en peck deck", .machine, "Pecho"),
        ("Press militar en máquina", .machine, "Hombros"),
        ("Abdomen en máquina", .machine, "Abdomen"),
        ("Pull up asistido en máquina", .machine, "Espalda"),
        ("Remo en barra T con agarre neutro", .machine, "Espalda"),
        ("Jalón al pecho con agarre neutro", .machine, "Espalda"),
        ("Curl predicador en máquina", .machine, "Brazos"),
        ("Aductores en máquina", .machine, "Piernas"),
        ("Abductores en máquina", .machine, "Piernas"),
        ("Sentadilla Hack (máquina)", .machine, "Piernas"),
        ("Elevación de talones de pie en máquina", .machine, "Piernas"),

        // Poleas
        ("Jalón de tríceps en polea", .cable, "Brazos"),
        ("Curl de bíceps en polea", .cable, "Brazos"),
        ("Cruce de poleas (pec deck cable)", .cable, "Pecho"),
        ("Face pull en polea", .cable, "Hombros"),
        ("Remo sentado en polea", .cable, "Espalda"),
        ("Pull-over en polea", .cable, "Espalda"),
        ("Patada de tríceps en polea", .cable, "Brazos"),
        ("Elevaciones laterales en polea", .cable, "Hombros"),
        ("Extensión de tríceps sobre la cabeza en polea (agarre V)", .cable, "Brazos"),
        ("Extensión de tríceps en polea alta (agarre V)", .cable, "Brazos"),
        ("Curl Bayesian en polea", .cable, "Brazos"),
    ]

    @discardableResult
    private static func seedExercises(context: ModelContext) -> [String: Exercise] {
        var byName: [String: Exercise] = [:]
        for definition in exerciseDefinitions {
            let exercise = Exercise(name: definition.name, category: definition.category, muscleGroup: definition.muscle, isCustom: false)
            context.insert(exercise)
            byName[definition.name] = exercise
        }
        return byName
    }

    private struct DayPlan {
        let name: String
        let symbol: String
        let slots: [(name: String, sets: Int, low: Int, high: Int)]
    }

    private static let dayPlans: [DayPlan] = [
        DayPlan(name: "Push", symbol: "arrow.up.circle.fill", slots: [
            ("Press banca en máquina", 4, 6, 10),
            ("Press inclinado en máquina", 3, 8, 12),
            ("Aperturas en peck deck", 3, 12, 15),
            ("Elevaciones laterales", 3, 12, 15),
            ("Press militar en máquina", 3, 8, 12),
            ("Extensión de tríceps sobre la cabeza en polea (agarre V)", 3, 10, 15),
            ("Extensión de tríceps en polea alta (agarre V)", 3, 10, 15),
            ("Abdomen en máquina", 3, 12, 20),
        ]),
        DayPlan(name: "Pull", symbol: "arrow.down.circle.fill", slots: [
            ("Pull up asistido en máquina", 4, 6, 10),
            ("Remo en barra T con agarre neutro", 3, 8, 12),
            ("Jalón al pecho con agarre neutro", 3, 10, 12),
            ("Curl martillo con mancuernas", 3, 10, 12),
            ("Curl predicador en máquina", 3, 10, 12),
            ("Curl predicador con barra Z", 2, 10, 12),
            ("Curl Bayesian en polea", 3, 10, 12),
            ("Curl de muñeca con barra", 3, 15, 20),
            ("Curl de muñeca inverso con barra", 3, 15, 20),
            ("Abdomen en máquina", 3, 12, 20),
        ]),
        DayPlan(name: "Legs", symbol: "figure.strengthtraining.traditional", slots: [
            ("Aductores en máquina", 3, 12, 15),
            ("Abductores en máquina", 3, 12, 15),
            ("Sentadilla Hack (máquina)", 4, 6, 10),
            ("Extensión de cuádriceps", 3, 12, 15),
            ("Curl femoral en máquina", 3, 10, 15),
            ("Hip thrust con barra", 3, 8, 12),
            ("Elevación de talones de pie en máquina", 4, 12, 15),
        ]),
        DayPlan(name: "Upper", symbol: "figure.arms.open", slots: [
            ("Press banca en máquina", 3, 6, 10),
            ("Jalón al pecho con agarre neutro", 3, 8, 12),
            ("Press militar en máquina", 3, 8, 12),
            ("Remo en barra T con agarre neutro", 3, 8, 12),
            ("Curl martillo con mancuernas", 3, 10, 12),
            ("Extensión de tríceps en polea alta (agarre V)", 3, 10, 15),
            ("Elevaciones laterales", 3, 12, 15),
        ]),
        DayPlan(name: "Lower", symbol: "figure.run", slots: [
            ("Sentadilla Hack (máquina)", 4, 6, 10),
            ("Peso muerto", 3, 5, 8),
            ("Extensión de cuádriceps", 3, 12, 15),
            ("Curl femoral en máquina", 3, 10, 15),
            ("Hip thrust con barra", 3, 8, 12),
            ("Aductores en máquina", 3, 12, 15),
            ("Elevación de talones de pie en máquina", 4, 12, 15),
        ]),
    ]

    private static func seedDays(context: ModelContext, exercises: [String: Exercise]) {
        for (index, plan) in dayPlans.enumerated() {
            let day = WorkoutDay(name: plan.name, symbolName: plan.symbol, order: index)
            context.insert(day)
            insertSlots(plan.slots, into: day, exercises: exercises, context: context)
        }
    }

    private static func insertSlots(
        _ slotDefinitions: [(name: String, sets: Int, low: Int, high: Int)],
        into day: WorkoutDay,
        exercises: [String: Exercise],
        context: ModelContext
    ) {
        for (slotIndex, definition) in slotDefinitions.enumerated() {
            guard let exercise = exercises[definition.name] else { continue }
            let newSlot = DayExerciseSlot(
                exercise: exercise,
                order: slotIndex,
                targetSets: definition.sets,
                targetRepsLow: definition.low,
                targetRepsHigh: definition.high
            )
            newSlot.day = day
            context.insert(newSlot)
        }
    }
}
