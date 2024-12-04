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
        .init(reps: nil, weight: nil)
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
                        
                        // Sets Header
                        HStack {
                            Text("Set")
                                .font(.headline)
                                .bold()
                                .frame(width: 40)
                            Text("Reps")
                                .font(.headline)
                                .bold()
                                .frame(maxWidth: .infinity)
                            Text("Weight")
                                .font(.headline)
                                .bold()
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal)
                        
                        // Sets List
                        ForEach(Array(sets.enumerated()), id: \.element.id) { index, set in
                            HStack {
                                Text("\(index + 1)")
                                    .font(.headline)
                                    .bold()
                                    .frame(width: 40)
                                
                                TextField("0", text: Binding(
                                    get: { sets[index].reps == nil ? "" : "\(sets[index].reps!)" },
                                    set: { sets[index].reps = Int($0) }
                                ))
                                .keyboardType(.numberPad)
                                .frame(maxWidth: .infinity)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                TextField("0", text: Binding(
                                    get: { sets[index].weight == nil ? "" : "\(sets[index].weight!)" },
                                    set: { sets[index].weight = Double($0) }
                                ))
                                .keyboardType(.numberPad)
                                .frame(maxWidth: .infinity)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            .padding(.horizontal)
                        }
                        
                        // Add/Remove Set Buttons
                        VStack(spacing: 12) {
                            Button(action: { sets.append(.init()) }) {
                                Text("Add Set")
                                    .font(.headline)
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
                            
                            if sets.count > 1 {
                                Button(action: { sets.removeLast() }) {
                                    Text("Remove Set")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.red, .orange]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .foregroundColor(.white)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.top)
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
