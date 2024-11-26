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
    
    let exercises: [Exercise] = [
        Exercise(name: "Back Rows", duration: "15 Mins", calories: "100Kcals", icon: "figure.strengthtraining.traditional"),
        Exercise(name: "Lat Pulldown", duration: "15 Mins", calories: "100Kcals", icon: "figure.strengthtraining.functional")
    ]
    
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
        VStack(spacing: 16) {
            HStack {
                Text(exercise.name)
                    .font(.title2)
                    .bold()
                Spacer()
                Image(systemName: "pencil")
                    .foregroundColor(.black)
            }
            
            HStack {
                Image(systemName: exercise.icon)
                    .font(.system(size: 60))
                Spacer()
                VStack(alignment: .trailing, spacing: 8) {
                    HStack {
                        Image(systemName: "clock")
                        Text(exercise.duration)
                    }
                    HStack {
                        Image(systemName: "flame")
                        Text(exercise.calories)
                    }
                }
            }
            
            Button(action: {}) {
                Text("Start")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
    }
}


