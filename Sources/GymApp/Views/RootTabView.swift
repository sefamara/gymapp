import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            Tab("Rutina", systemImage: "calendar") {
                RoutineView()
            }
            Tab("Entrenar", systemImage: "figure.strengthtraining.traditional") {
                StartWorkoutView()
            }
            Tab("Progreso", systemImage: "chart.line.uptrend.xyaxis") {
                ProgressOverviewView()
            }
            Tab("Ejercicios", systemImage: "dumbbell") {
                ExerciseLibraryView()
            }
        }
        // On iOS 26 the tab bar automatically renders as Liquid Glass;
        // .tabBarMinimizeBehavior lets it condense while scrolling workout lists.
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

#Preview {
    RootTabView()
        .modelContainer(PreviewData.container)
}
