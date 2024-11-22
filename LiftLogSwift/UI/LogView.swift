//
//  LogView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-21.
//

import SwiftUI

struct LogView: View {
    @State private var selectedTab = "Goals"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Custom Tab Picker
                Picker("View Selection", selection: $selectedTab) {
                    Text("Goals").tag("Goals")
                    Text("My Lift Log").tag("My Lift Log")
                }
                .pickerStyle(.segmented)
                .padding()
                
                if selectedTab == "Goals" {
                    GoalsContent()
                } else {
                    LiftLogContent()
                }
                
                Spacer()
            }
            .navigationBarItems(leading: Button(action: {}) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.black)
            })
            .navigationBarTitle(selectedTab, displayMode: .inline)
        }
    }
}

struct GoalsContent: View {
    @StateObject private var goalStore = GoalStore()
    @State private var showAddGoal = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Add Button
                HStack {
                    Spacer()
                    Button(action: {
                        showAddGoal = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Circle().fill(Color.gray.opacity(0.1)))
                    }
                }
                .padding(.horizontal)
                .sheet(isPresented: $showAddGoal) {
                    AddGoalView(goalStore: goalStore)
                }
                
                // Goals List
                if goalStore.goals.isEmpty {
                    Text("No goals yet")
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                } else {
                    ForEach(goalStore.goals) { goal in
                        GoalCard(goal: goal)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

struct LiftLogContent: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                WorkoutLogCard(
                    title: "Chest Workout (heavy)",
                    date: "November 4, 2024 1h14m",
                    calories: "129",
                    duration: "1hr14m",
                    exercises: "7/7",
                    workoutDetails: [
                        "Incline DB- 15m12s",
                        "Incline DB- 15m12s",
                        "Incline DB- 15m12s"
                    ]
                )
                .padding(.horizontal)
            }
        }
    }
}

struct WorkoutLogCard: View {
    let title: String
    let date: String
    let calories: String
    let duration: String
    let exercises: String
    let workoutDetails: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.title2)
                        .bold()
                    Text(date)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "pencil")
                        .foregroundColor(.black)
                }
            }
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Calories")
                        .font(.subheadline)
                    Text("\(calories) Kcal")
                        .bold()
                    Text("Excercises \(exercises)")
                        .font(.caption)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.1)))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Duration")
                        .font(.subheadline)
                    Text(duration)
                        .bold()
                    Text("\(duration) Active/Rest")
                        .font(.caption)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.1)))
            }
            
            ForEach(workoutDetails, id: \.self) { detail in
                HStack {
                    Text(detail)
                        .font(.headline)
                    Spacer()
                    Text("3 sets 2 minutes 20,25,30lbs")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.1)))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.1), radius: 10)
    }
}

#Preview {
    LogView()
}


