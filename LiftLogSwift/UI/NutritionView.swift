////
////  NutritionView.swift
////  LiftLogSwift
////
////  Created by Nathaniel D'Orazio on 2024-11-21.
////
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
                            .padding(.top)
                        
                        // Hardcoded meal cards
                        MealCard(mealType: "Breakfast", calories: "650 kcal", time: "7:30 AM")
                        MealCard(mealType: "Snack", calories: "200 kcal", time: "10:00 AM")
                        MealCard(mealType: "Lunch", calories: "800 kcal", time: "12:30 PM")
                        MealCard(mealType: "Afternoon Snack", calories: "150 kcal", time: "3:00 PM")
                        MealCard(mealType: "Dinner", calories: "900 kcal", time: "6:30 PM")
                        MealCard(mealType: "Supper", calories: "300 kcal", time: "9:00 PM")
                        MealCard(mealType: "Brunch", calories: "500 kcal", time: "11:00 AM")
                    }
                    .padding(.top)
                }
                .padding()
                .navigationTitle("Nutrition")
                .navigationBarTitleDisplayMode(.inline) // Optional: makes title inline
            }
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

// MealCard struct is declared here
//struct MealCard: View {
//    let mealType: String
//    let calories: String
//    let time: String
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text(mealType)
//                .font(.title3)
//                .fontWeight(.bold)
//            
//            HStack {
//                Text("Calories: \(calories)")
//                    .foregroundColor(.gray)
//                Spacer()
//                Text("Time: \(time)")
//                    .foregroundColor(.gray)
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(radius: 5)
//    }
//}

#Preview{
        NutritionView()
    }



