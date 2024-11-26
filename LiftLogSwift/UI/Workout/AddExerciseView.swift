//
//  AddExerciseView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI


struct AddExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var routineStore: RoutineStore
    @Binding var routine: Routine
    @State private var exerciseName = ""
    @State private var duration = ""
    @State private var calories = ""
    @State private var selectedIcon = "figure.strengthtraining.traditional"
    
    let icons = [
        "figure.strengthtraining.traditional",
        "figure.strengthtraining.functional",
        "figure.highintensity.intervaltraining",
        "figure.core.training",
        "figure.climbing"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Exercise Name")
                            .font(.title2)
                            .bold()
                        
                        TextField("Bulgarian Split Squats", text: $exerciseName)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Duration")
                            .font(.title2)
                            .bold()
                        
                        TextField("15 Mins", text: $duration)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Calories")
                            .font(.title2)
                            .bold()
                        
                        TextField("100Kcals", text: $calories)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Icon")
                            .font(.title2)
                            .bold()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(icons, id: \.self) { icon in
                                    Image(systemName: icon)
                                        .font(.system(size: 30))
                                        .padding()
                                        .background(selectedIcon == icon ? Color.gray.opacity(0.2) : Color.clear)
                                        .clipShape(Circle())
                                        .onTapGesture {
                                            selectedIcon = icon
                                        }
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        if !exerciseName.isEmpty {
                            let newExercise = Exercise(
                                name: exerciseName,
                                duration: duration.isEmpty ? "15 Mins" : duration,
                                calories: calories.isEmpty ? "100Kcals" : calories,
                                icon: selectedIcon
                            )
                            routine.exercises.append(newExercise)
                            routineStore.addExercise(to: routine.id, exercise: newExercise)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Add Exercise")
                            .font(.headline)
                            .bold()
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
                .padding()
            }
            .navigationTitle("Add Exercise")
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            )
        }
    }
}





