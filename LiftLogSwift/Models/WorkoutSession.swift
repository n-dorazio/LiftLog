//
//  WorkoutSession.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-12-03.
//

import Foundation

struct WorkoutSession: Identifiable, Codable {
    var id: UUID
    var routineName: String
    var date: Date
    var duration: TimeInterval
    var totalCalories: Int
    var exercises: [ExerciseSession]
    
    struct ExerciseSession: Identifiable, Codable {
        var id: UUID
        var name: String
        var icon: String
        var sets: [SetData]
        var duration: TimeInterval
        
        struct SetData: Identifiable, Codable {
            var id: UUID
            var reps: Int?
            var weight: Double?
            
            init(reps: Int? = nil, weight: Double? = nil) {
                self.id = UUID()
                self.reps = reps
                self.weight = weight
            }
        }
        
        init(id: UUID = UUID(), name: String, icon: String, sets: [SetData] = [], duration: TimeInterval = 0) {
            self.id = id
            self.name = name
            self.icon = icon
            self.sets = sets
            self.duration = duration
        }
    }
    
    init(id: UUID = UUID(), routineName: String, date: Date, duration: TimeInterval,totalCalories: Int, exercises: [ExerciseSession]) {
        self.id = id
        self.routineName = routineName
        self.date = date
        self.duration = duration
        self.totalCalories = totalCalories
        self.exercises = exercises
    }
}
