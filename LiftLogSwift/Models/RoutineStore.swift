//
//  RoutineStore.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import Foundation

class RoutineStore: ObservableObject {
    @Published var routines: [Routine] {
        didSet {
            saveRoutines()
        }
    }
    
    private let userDefaultsKey = "savedRoutines"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedRoutines = try? JSONDecoder().decode([Routine].self, from: data) {
            self.routines = decodedRoutines
        } else {
            // Initialize with default routines if no saved data exists
            self.routines = [
                Routine(name: "Full Body Challenge", exercises: [
                    Exercise(name: "Burpees", notes: "3 sets of 10 reps"),
                    Exercise(name: "Mountain Climbers", notes: "3 sets of 30 seconds"),
                    Exercise(name: "Push-Ups", notes: "3 sets of 12 reps")
                ]),
                Routine(name: "Chest Day", exercises: [
                    Exercise(name: "Bench Press", notes: "4 sets of 10 reps"),
                    Exercise(name: "Incline Dumbbell Press", notes: "3 sets of 12 reps"),
                    Exercise(name: "Cable Flyes", notes: "3 sets of 15 reps")
                ]),
                Routine(name: "Leg Day", exercises: [
                    Exercise(name: "Squats", notes: "4 sets of 10 reps"),
                    Exercise(name: "Romanian Deadlifts", notes: "3 sets of 12 reps"),
                    Exercise(name: "Leg Press", notes: "3 sets of 15 reps")
                ])
            ]
        }
    }
    
    private func saveRoutines() {
        if let encoded = try? JSONEncoder().encode(routines) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    func addRoutine(name: String) {
        let routine = Routine(name: name)
        routines.append(routine)
    }
    
    func addExercise(to routineId: UUID, exercise: Exercise) {
        if let index = routines.firstIndex(where: { $0.id == routineId }) {
            var updatedRoutine = routines[index]
            updatedRoutine.exercises.append(exercise)
            routines[index] = updatedRoutine
        }
    }
    
    func deleteRoutine(id: UUID) {
        routines.removeAll { $0.id == id }
    }
    
    func deleteExercise(routineId: UUID, exerciseId: UUID) {
        if let index = routines.firstIndex(where: { $0.id == routineId }) {
            var updatedRoutine = routines[index]
            updatedRoutine.exercises.removeAll { $0.id == exerciseId }
            routines[index] = updatedRoutine
        }
    }
    
    func moveExercise(routineId: UUID, from source: IndexSet, to destination: Int) {
        if let routineIndex = routines.firstIndex(where: { $0.id == routineId }) {
            var updatedRoutine = routines[routineIndex]
            updatedRoutine.exercises.move(fromOffsets: source, toOffset: destination)
            routines[routineIndex] = updatedRoutine
            saveRoutines()
        }
    }
}



