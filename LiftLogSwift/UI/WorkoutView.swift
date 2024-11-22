//
//  WorkoutView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-21.
//


import SwiftUI

struct WorkoutView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Workout Cards
                    WorkoutCard(
                        title: "Full Body Workout",
                        duration: "45 min",
                        exercises: "12 exercises"
                    )
                    
                    // Recent Workouts
                    VStack(alignment: .leading) {
                        Text("Recent Workouts")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(0..<3) { _ in
                            WorkoutHistoryItem(
                                name: "Upper Body",
                                date: "Today",
                                duration: "45 min"
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Workouts")
        }
    }
}

struct WorkoutCard: View {
    let title: String
    let duration: String
    let exercises: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title2)
                .bold()
            
            HStack {
                Label(duration, systemImage: "clock")
                Spacer()
                Label(exercises, systemImage: "figure.run")
            }
            .font(.subheadline)
            .foregroundColor(.gray)
            
            Button(action: {}) {
                Text("Start Workout")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }
}
