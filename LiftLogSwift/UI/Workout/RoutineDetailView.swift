//
//  RoutineDetailView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI

struct RoutineDetailView: View {
    @ObservedObject var routineStore: RoutineStore
    @Binding var routine: Routine
    @Environment(\.presentationMode) var presentationMode
    @State private var showAddExercise = false
    @State private var selectedExerciseIndex: Int?
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(routine.exercises.enumerated()), id: \.element.id) { index, exercise in
                    VStack(spacing: 16) {
                        HStack {
                            Text(exercise.name)
                                .font(.title2)
                                .bold()
                            Spacer()
                            if isEditing {
                                Image(systemName: "line.3.horizontal")
                                    .foregroundColor(.gray)
                            }
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
                        
                        Button(action: {
                            selectedExerciseIndex = routine.exercises.firstIndex(where: { $0.id == exercise.id })
                        }) {
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
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            routineStore.deleteExercise(routineId: routine.id, exerciseId: exercise.id)
                            routine.exercises.removeAll { $0.id == exercise.id }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
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
                AddExerciseView(routineStore: routineStore, routine: $routine)
            }
            .sheet(isPresented: Binding(
                get: { selectedExerciseIndex != nil },
                set: { if !$0 { selectedExerciseIndex = nil } }
            )) {
                if let index = selectedExerciseIndex {
                    WorkoutSessionView(routine: routine, initialExerciseIndex: index)
                }
            }
        }
    }
}

// Helper struct to make the index Identifiable
struct IndexWrapper: Identifiable {
    let id = UUID()
    let index: Int
}



