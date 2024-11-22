//
//  NutritionView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-21.
//

import SwiftUI

struct NutritionView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Calories Progress
                    CaloriesCard(
                        consumed: 1865,
                        goal: 2500
                    )
                    
                    // Meals List
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Today's Meals")
                            .font(.headline)
                        
                        ForEach(["Breakfast", "Lunch", "Dinner"], id: \.self) { meal in
                            MealCard(
                                mealType: meal,
                                calories: "650 kcal",
                                time: "8:30 AM"
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Nutrition")
        }
    }
}

struct CaloriesCard: View {
    let consumed: Int
    let goal: Int
    
    var body: some View {
        VStack(spacing: 15) {
            Text("\(consumed)")
                .font(.system(size: 40, weight: .bold))
            Text("calories consumed")
                .foregroundColor(.gray)
            
            ProgressView(value: Double(consumed), total: Double(goal))
                .tint(.orange)
            
            Text("Goal: \(goal) kcal")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }
}
