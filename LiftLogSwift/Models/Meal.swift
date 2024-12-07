//
//  Meal.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-12-07.
//

import Foundation

struct Meal: Identifiable, Equatable {
    let id: UUID
    let title: String
    let calories: Int
    let protein: Double
    let fats: Double
    let carbs: Double
    let description: String
    let time: Date
    
    init(id: UUID = UUID(), title: String, calories: Int, protein: Double, fats: Double, carbs: Double, description: String, time: Date) {
        self.id = id
        self.title = title
        self.calories = calories
        self.protein = protein
        self.fats = fats
        self.carbs = carbs
        self.description = description
        self.time = time
    }
}
