//
//  ExerciseListView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI

struct ExerciseListView: View {
    let categoryTitle: String
    @Environment(\.presentationMode) var presentationMode
    
    let exercises: [Exercise] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(exercises) { exercise in
                        WorkoutExerciseCard(exercise: exercise)
                    }
                }
                .padding()
            }
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                },
                trailing: Button(action: {}) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.orange, .red]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                }
            )
            .navigationTitle("\(categoryTitle)")
        }
    }
}

struct WorkoutExerciseCard: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with exercise name
            HStack {
                Text(exercise.name)
                    .font(.system(size: 24, weight: .bold))
                Spacer()
                Image(systemName: "pencil")
                    .foregroundColor(.orange)
            }
            
            // Icon with stats
            HStack(spacing: 30) {
                Image(systemName: exercise.icon)
                    .font(.system(size: 50))
                    .foregroundColor(.orange)
                    .padding()
                    .background(
                        Circle()
                            .fill(Color.orange.opacity(0.2))
                            .frame(width: 100, height: 100)
                    )
                
                Spacer()
                
                // Stats
                VStack(alignment: .trailing, spacing: 12) {
                    HStack {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.orange)
                        Text(exercise.duration)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.orange)
                        Text(exercise.calories)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            // Start Button
            Button(action: {}) {
                HStack {
                    Text("Start Exercise")
                        .font(.title3)
                        .bold()
                    Image(systemName: "arrow.right")
                        .font(.title3)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.orange, .red]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(20)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.1), radius: 10)
    }
}


