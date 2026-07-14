# GymApp

App nativa de iOS (SwiftUI + SwiftData + Liquid Glass) para trackear series, repeticiones y ejercicios de gym, con rutina organizada por días editables (Push, Pull, Legs, Upper, Lower, o los que definas) y progreso histórico por ejercicio.

## Requisitos

- macOS con **Xcode 26** o superior (Liquid Glass y las APIs `.glassEffect()` / `GlassEffectContainer` requieren el SDK de iOS 26).
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) para generar el `.xcodeproj` a partir de `project.yml`:
  ```bash
  brew install xcodegen
  ```
- Un iPhone 15 Pro Max (o simulador) con iOS 26+.

Este proyecto se desarrolló en Windows, por lo que no se pudo compilar ni ejecutar aquí — el código está listo para abrir y correr en Xcode en una Mac.

## Generar y abrir el proyecto

```bash
cd GymApp
xcodegen generate
open GymApp.xcodeproj
```

En Xcode:
1. Selecciona el target `GymApp` → pestaña **Signing & Capabilities** → elige tu Apple ID / equipo de desarrollo.
2. Si no quieres usar iCloud sync todavía, abre `Sources/GymApp/GymAppApp.swift` y cambia `cloudKitDatabase: .automatic` por `cloudKitDatabase: .none` (evita tener que configurar el contenedor de CloudKit).
3. Corre en el simulador de iPhone 15 Pro Max o en tu dispositivo físico (⌘R).

### ¿No tienes Mac ni cuenta de Apple Developer paga?

Ver [`SIDELOADING.md`](SIDELOADING.md): compila el `.ipa` gratis en GitHub Actions y sideloadéalo con SideStore usando un Apple ID gratis, con refresco de firma por internet (no necesitas estar en la misma wifi que ninguna computadora).

## Estructura

```
Sources/GymApp/
  GymAppApp.swift          # Entry point, ModelContainer (SwiftData + iCloud)
  Models/                  # Exercise, WorkoutDay, DayExerciseSlot, WorkoutSession, SetEntry, SeedData
  DesignSystem/            # Theme, GlassCard — helpers de Liquid Glass
  Views/
    RootTabView.swift      # Tab bar Liquid Glass: Rutina / Entrenar / Progreso / Ejercicios
    Routine/                # Lista de días, detalle de día, agregar día
    ExercisePicker/         # Selector por categoría (peso libre / máquina / poleas), biblioteca, alta de ejercicio
    Workout/                # Iniciar entrenamiento, registrar series/reps/peso
    Progress/                # Resumen y gráfica (Swift Charts) de 1RM estimado por ejercicio
```

## Qué trae de fábrica

- Biblioteca semilla con ~28 ejercicios comunes clasificados en **peso libre / máquina / poleas**.
- 5 días precargados y completamente editables: **Push, Pull, Legs, Upper, Lower** — pensado para que ajustes tu split actual (PPL) hacia PPL/UL sin partir de cero: borra, renombra o reordena los días y ejercicios que no uses.
- Registro de series con reps + peso, con progreso estimado de 1RM (fórmula de Epley) por ejercicio en la pestaña Progreso.

## Próximos pasos sugeridos

- Reemplazar el ícono placeholder en `Assets.xcassets/AppIcon.appiconset`.
- Ajustar `DEVELOPMENT_TEAM` en `project.yml` si quieres fijar tu equipo de firma en el propio archivo.
- Si activas iCloud sync, crea el contenedor CloudKit `iCloud.com.gymapp.tracker` (o el bundle ID que elijas) desde el portal de desarrollador de Apple.
