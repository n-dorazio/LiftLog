//
//  RoutineStore.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import Foundation

class RoutineStore: ObservableObject {
    @Published var routines: [Routine] = [
        // Full Body Challenge
        Routine(name: "Full Body Challenge", exercises: [
            Exercise(name: "Burpees", notes: "3 sets of 10 reps"),
            Exercise(name: "Mountain Climbers", notes: "3 sets of 30 seconds"),
            Exercise(name: "Push-Ups", notes: "3 sets of 12 reps")
        ]),
        
        // Chest Day
        Routine(name: "Chest Day", exercises: [
            Exercise(name: "Bench Press", notes: "4 sets of 10 reps"),
            Exercise(name: "Incline Dumbbell Press", notes: "3 sets of 12 reps"),
            Exercise(name: "Cable Flyes", notes: "3 sets of 15 reps")
        ]),
        
        // Leg Day
        Routine(name: "Leg Day", exercises: [
            Exercise(name: "Squats", notes: "4 sets of 10 reps"),
            Exercise(name: "Romanian Deadlifts", notes: "3 sets of 12 reps"),
            Exercise(name: "Leg Press", notes: "3 sets of 15 reps")
        ])
    ]
    
    func addRoutine(name: String) {
        let routine = Routine(name: name)
        routines.append(routine)
    }
    
    func addExercise(to routineId: UUID, exercise: Exercise) {
        if let index = routines.firstIndex(where: { $0.id == routineId }) {
            routines[index].exercises.append(exercise)
        }
    }
}


