//
//  MealStore.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-12-07.
//

import Foundation

class MealStore: ObservableObject {
    @Published var meals: [Meal] = []
    
    init() {
        // Add a default meal
        let defaultMeal = Meal(
            title: "Breakfast",
            calories: 450,
            protein: 25.0,
            fats: 15.0,
            carbs: 55.0,
            description: "Oatmeal with protein powder and banana",
            time: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date()
        )
        addMeal(defaultMeal)
    }
    
    func addMeal(_ meal: Meal) {
        meals.append(meal)
        // Sort meals by time
        meals.sort { $0.time < $1.time }
    }
    
    func deleteMeal(_ meal: Meal) {
        meals.removeAll { $0.id == meal.id }
    }
    
    func updateMeal(_ updatedMeal: Meal) {
        if let index = meals.firstIndex(where: { $0.id == updatedMeal.id }) {
            meals[index] = updatedMeal
            // Sort meals by time
            meals.sort { $0.time < $1.time }
        }
    }
    
    func mealsForDate(_ date: Date) -> [Meal] {
        let calendar = Calendar.current
        return meals.filter { meal in
            calendar.isDate(meal.time, inSameDayAs: date)
        }
    }
}
