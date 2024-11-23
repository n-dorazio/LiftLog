//
//  WorkoutView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-21.
//


import SwiftUI

struct WorkoutView: View {
    @StateObject private var routineStore = RoutineStore()
    @State private var selectedCategory: String?
    @State private var showAddRoutine = false
    @State private var selectedRoutine: Routine?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(workoutCategories, id: \.self) { category in
                        VStack(spacing: 16) {
                            Button(action: {
                                selectedCategory = category
                            }) {
                                HStack {
                                    Text(category)
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        .background(Color.white)
                                )
                            }
                            
                            // Show routines for this category
                            ForEach(routineStore.routines.filter { $0.category == category }) { routine in
                                Button(action: {
                                    selectedRoutine = routine
                                }) {
                                    HStack {
                                        Text(routine.name)
                                            .font(.title3)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.gray.opacity(0.1))
                                    )
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Workout Routines")
            .navigationBarItems(
                leading: Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                },
                trailing: Button(action: {
                    showAddRoutine = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            )
            .sheet(isPresented: $showAddRoutine) {
                AddRoutineView(routineStore: routineStore, selectedCategory: selectedCategory ?? workoutCategories[0])
                    .presentationDetents([.height(250)])
            }
            .sheet(item: $selectedCategory) { category in
                ExerciseListView(categoryTitle: category)
            }
            .sheet(item: $selectedRoutine) { routine in
                EmptyRoutineView(routineName: routine.name)
            }
        }
    }
    
    private let workoutCategories = [
        "Weekly Challenge",
        "Core Exercises",
        "Pull Exercises",
        "Push Exercises",
        "Leg Workouts"
    ]
}

extension String: Identifiable {
    public var id: String { self }
}

