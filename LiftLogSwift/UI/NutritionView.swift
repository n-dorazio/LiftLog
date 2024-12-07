//
//  NutritionView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-21.
//



import SwiftUI

struct NutritionView: View {
    @StateObject private var mealStore = MealStore()
    @State private var selectedDate = Date()
    @State private var showCalendar = false
    @State private var showNewMeal = false
    @State private var mealToEdit: Meal?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMM"
        return formatter
    }()
    
    var formattedDate: String {
        return dateFormatter.string(from: selectedDate)
    }
    
    var totalCalories: Int {
        mealStore.mealsForDate(selectedDate).reduce(0) { $0 + $1.calories }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Title and Calendar section
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Nutrition")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                    Text(formattedDate)
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
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
                            
                            // Calories Card
                            CaloriesCard(consumed: totalCalories, goal: 2500)
                            
                            // Add Meal Button
                            Button(action: {
                                showNewMeal = true
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Meal")
                                }
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(colors: [.orange, .red], 
                                                 startPoint: .topLeading, 
                                                 endPoint: .bottomTrailing)
                                )
                                .foregroundColor(.white)
                                .cornerRadius(15)
                            }
                        }
                        .padding()
                    }
                    
                    // Meals List Section
                    VStack(alignment: .leading) {
                        Text("Today's Meals")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        List {
                            ForEach(mealStore.mealsForDate(selectedDate)) { meal in
                                MealCard(
                                    meal: meal,
                                    onDelete: {
                                        mealStore.deleteMeal(meal)
                                    },
                                    onEdit: {
                                        mealToEdit = meal
                                    }
                                )
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                            }
                        }
                        .listStyle(PlainListStyle())
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
        .sheet(isPresented: $showNewMeal) {
            NewMealView(mealStore: mealStore)
        }
        .sheet(item: $mealToEdit) { meal in
            NewMealView(mealStore: mealStore, editingMeal: meal)
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
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var mealStore: MealStore
    @State private var mealTitle = ""
    @State private var protein = ""
    @State private var calories = ""
    @State private var fats = ""
    @State private var carbs = ""
    @State private var mealDescription = ""
    @State private var selectedTime = Date()
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var editingMeal: Meal?
    
    init(mealStore: MealStore, editingMeal: Meal? = nil) {
        self.mealStore = mealStore
        self.editingMeal = editingMeal
        
        if let meal = editingMeal {
            _mealTitle = State(initialValue: meal.title)
            _calories = State(initialValue: String(meal.calories))
            _protein = State(initialValue: String(meal.protein))
            _fats = State(initialValue: String(meal.fats))
            _carbs = State(initialValue: String(meal.carbs))
            _mealDescription = State(initialValue: meal.description)
            _selectedTime = State(initialValue: meal.time)
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Group {
                        TextField("Meal Title", text: $mealTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        DatePicker("Time", selection: $selectedTime, displayedComponents: [.hourAndMinute])
                        
                        TextField("Calories", text: $calories)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Protein (g)", text: $protein)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Fats (g)", text: $fats)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Carbs (g)", text: $carbs)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal)
                    
                    TextEditor(text: $mealDescription)
                        .frame(height: 100)
                        .padding(4)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle(editingMeal != nil ? "Edit Meal" : "New Meal")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveMeal()
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func saveMeal() {
        guard !mealTitle.isEmpty else {
            alertMessage = "Please enter a meal title"
            showAlert = true
            return
        }
        
        guard let caloriesInt = Int(calories),
              let proteinDouble = Double(protein),
              let fatsDouble = Double(fats),
              let carbsDouble = Double(carbs) else {
            alertMessage = "Please enter valid numbers for calories and macros"
            showAlert = true
            return
        }
        
        let meal = Meal(
            id: editingMeal?.id ?? UUID(),
            title: mealTitle,
            calories: caloriesInt,
            protein: proteinDouble,
            fats: fatsDouble,
            carbs: carbsDouble,
            description: mealDescription,
            time: selectedTime
        )
        
        if editingMeal != nil {
            mealStore.updateMeal(meal)
        } else {
            mealStore.addMeal(meal)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NutritionView()
}
