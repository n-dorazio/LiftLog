//
//  NutritionView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-21.
//



import SwiftUI

struct NutritionView: View {
    @State private var selectedDate = Date()  // State for the selected date
    @State private var showCalendar = false   // State for showing the calendar popup
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Title and Calendar Toggle Button
                    HStack {
                        Text("Nutrition")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        // Calendar Toggle Button
                        Button(action: {
                            withAnimation {
                                showCalendar.toggle()
                            }
                        }) {
                            Image(systemName: "calendar")
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding(12)
                                .background(Circle().fill(Color.white))
                                .shadow(color: .gray.opacity(0.2), radius: 5)
                        }
                    }
                    .padding(.top)
                    
                    // Calories Progress
                    CaloriesCard(
                        consumed: 1883,
                        goal: 2500
                    )
                    
                    // Meal Creation Button (NavigationLink)
                    NavigationLink(destination: NewMealView()) {
                        Text("Create New Meal")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Capsule().fill(Color.orange))
                            .foregroundColor(.white)
                            .shadow(color: .gray.opacity(0.3), radius: 5)
                    }
                    
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
            }
        }
        
        // Calendar Popup
        if showCalendar {
            VStack {
                CalendarView(selectedDate: $selectedDate) {
                    withAnimation {
                        showCalendar = false
                    }
                }
                .background(
                    Color.white
                        .cornerRadius(20)
                        .shadow(radius: 10)
                )
                .padding()
                .transition(.scale(scale: 0.95))
                
                Spacer()
            }
            .background(
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            showCalendar.toggle()
                        }
                    }
            )
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

// New Meal View (Page)
struct NewMealView: View {
    @State private var mealTitle = ""
    @State private var protein = ""
    @State private var calories = ""
    @State private var fats = ""
    @State private var carbs = ""
    @State private var mealDescription = ""
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Text("Create a New Meal")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
            }
            
            // Meal Title Text Field
            TextField("Meal Title", text: $mealTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Calories Text Field
            TextField("Calories", text: $calories)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Protein Text Field
            TextField("Protein (g)", text: $protein)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Fats Text Field
            TextField("Fats (g)", text: $fats)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Carbs Text Field
            TextField("Carbs (g)", text: $carbs)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Meal Description TextEditor
            TextEditor(text: $mealDescription)
                .frame(width:375, height: 150)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.bottom)
            
            
            // Save Button
            Button(action: {
                // Add functionality to save the new meal
                //print("Meal Saved: \(mealTitle), Protein: \(protein)g, Calories: \(calories) kcal, Fats: \(fats)g, Carbs: \(carbs)g, Description : \(mealDescription)")
            }) {
                Text("Save Meal")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Capsule().fill(Color.orange))
                    .foregroundColor(.white)
                    .padding()
            }
            .padding(.top)
            
            Spacer()
        }
    }
}


//
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



#Preview {
    NutritionView()
}
