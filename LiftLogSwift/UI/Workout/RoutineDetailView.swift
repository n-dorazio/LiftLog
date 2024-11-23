//
//  RoutineDetailView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI

struct RoutineDetailView: View {
    @ObservedObject var routineStore: RoutineStore
    let routine: Routine
    @Environment(\.presentationMode) var presentationMode
    @State private var showAddExercise = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                if routine.exercises.isEmpty {
                    VStack {
                        Spacer()
                        Text("Add Exercises to this Routine to see them here")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                } else {
                    VStack(spacing: 20) {
                        ForEach(routine.exercises) { exercise in
                            VStack(spacing: 16) {
                                HStack {
                                    Text(exercise.name)
                                        .font(.title2)
                                        .bold()
                                    Spacer()
                                    Image(systemName: "pencil")
                                        .foregroundColor(.gray)
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
                    .padding()
                }
            }
            .navigationTitle(routine.name)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                },
                trailing: Button(action: {
                    showAddExercise = true
                }) {
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
            .sheet(isPresented: $showAddExercise) {
                AddExerciseView(routineStore: routineStore, routine: routine)
            }
        }
    }
}

