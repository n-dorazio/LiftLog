//
//  AddLogExerciseView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-12-03.
//

import SwiftUI

struct AddLogExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var exercises: [WorkoutSession.ExerciseSession]
    @State private var exerciseName = ""
    @State private var selectedIcon = "figure.strengthtraining.traditional"
    @State private var isIconGridExpanded = false
    @State private var sets: [WorkoutSession.ExerciseSession.SetData] = [
        .init(reps: 0, weight: 0, restTime: 60)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Exercise Name Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Exercise Name")
                            .font(.title2)
                            .bold()
                        TextField("Exercise name", text: $exerciseName)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    // Icon Selection
                    VStack(alignment: .leading, spacing: 8) {
                        Button(action: {
                            withAnimation {
                                isIconGridExpanded.toggle()
                            }
                        }) {
                            HStack {
                                Text("Icon")
                                    .font(.title2)
                                    .bold()
                                Spacer()
                                Image(systemName: isIconGridExpanded ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        if isIconGridExpanded {
                            IconGridView(selectedIcon: $selectedIcon)
                        }
                    }
                    
                    // Sets
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Sets")
                            .font(.title2)
                            .bold()
                        
                        ForEach($sets) { $set in
                            HStack {
                                TextField("Reps", value: $set.reps, format: .number)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 80)
                                TextField("Weight", value: $set.weight, format: .number)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 80)
                                Spacer()
                                if sets.count > 1 {
                                    Button(action: { sets.removeLast() }) {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                        
                        Button(action: { sets.append(.init()) }) {
                            Text("Add Set")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Add Exercise")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveExercise()
                }
                .disabled(exerciseName.isEmpty)
            )
        }
    }
    
    private func saveExercise() {
        let exercise = WorkoutSession.ExerciseSession(
            name: exerciseName,
            icon: selectedIcon,
            sets: sets,
            duration: TimeInterval(sets.count * 60)
        )
        exercises.append(exercise)
        presentationMode.wrappedValue.dismiss()
    }
}
