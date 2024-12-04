//
//  AddWorkoutLogView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-12-03.
//

import SwiftUI

struct AddWorkoutLogView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var workoutStore: WorkoutStore
    @State private var routineName = ""
    @State private var date = Date()
    @State private var duration = ""
    @State private var exercises: [WorkoutSession.ExerciseSession] = []
    @State private var showAddExercise = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Routine Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Workout Name")
                            .font(.title2)
                            .bold()
                        TextField("Push Day", text: $routineName)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    // Date Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date")
                            .font(.title2)
                            .bold()
                        DatePicker("", selection: $date)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    // Duration
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Duration (minutes)")
                            .font(.title2)
                            .bold()
                        TextField("60", text: $duration)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    // Exercises
                    VStack(spacing: 16) {
                        VStack(spacing: 16) {
                            HStack {
                                Text("Exercises")
                                    .font(.title2)
                                    .bold()
                                Spacer()
                                Button(action: { showAddExercise = true }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                }
                            }
                            
                            List {
                                ForEach(exercises) { exercise in
                                    ExerciseLogRow(exercise: exercise)
                                        .listRowInsets(EdgeInsets())
                                        .listRowBackground(Color.clear)
                                        .listRowSeparator(.hidden)
                                        .padding(.vertical, 8)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                            Button(role: .destructive) {
                                                exercises.removeAll { $0.id == exercise.id }
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                            .listStyle(PlainListStyle())
                            .frame(minHeight: CGFloat(max(exercises.count * 90, 90)))
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                    }
                }
                .padding()
            }
            .navigationTitle("Add Workout")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveWorkout()
                }
                .disabled(routineName.isEmpty || duration.isEmpty)
            )
        }
        .sheet(isPresented: $showAddExercise) {
            AddLogExerciseView(exercises: $exercises)
        }
    }
    
    private func saveWorkout() {
        guard let durationInSeconds = Double(duration).map({ $0 * 60 }) else { return }
        
        let session = WorkoutSession(
            id: UUID(),
            routineName: routineName,
            date: date,
            duration: durationInSeconds,
            totalCalories: exercises.reduce(0) { total, exercise in
                total + (exercise.sets.count * 50) // 50 calories per set as an example
            },
            exercises: exercises
        )
        
        workoutStore.addSession(session)
        presentationMode.wrappedValue.dismiss()
    }
}

