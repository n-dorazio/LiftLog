//
//  Routine.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//
import Foundation

struct Routine: Identifiable, Codable {
    var id: UUID
    var name: String
    var exercises: [Exercise]
    
    init(id: UUID = UUID(), name: String, exercises: [Exercise] = []) {
        self.id = id
        self.name = name
        self.exercises = exercises
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case exercises
    }
    
    var totalDuration: String {
        let totalMinutes = exercises.reduce(0) { total, exercise in
            let components = exercise.duration.components(separatedBy: " ")
            if let minutes = Int(components[0]) {
                return total + minutes
            }
            return total
        }
        return "\(totalMinutes) min"
    }
    
    var totalCalories: String {
        let total = exercises.reduce(0) { total, exercise in
            let components = exercise.calories.components(separatedBy: " ")
            if let calories = Int(components[0]) {
                return total + calories
            }
            return total
        }
        return "\(total) cal"
    }
}
