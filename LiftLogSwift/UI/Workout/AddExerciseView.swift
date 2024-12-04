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
    @State private var selectedIcon = "figure.strengthtraining.traditional"
    @State private var isIconGridExpanded = false
    
    let icons = [
        "figure.strengthtraining.traditional",
        "figure.strengthtraining.functional",
        "figure.highintensity.intervaltraining",
        "figure.core.training",
        "figure.climbing",
        "figure.run",
        "figure.walk",
        "figure.boxing",
        "figure.dance",
        "figure.gymnastics",
        "figure.jumprope",
        "figure.mixed.cardio",
        "figure.pilates",
        "figure.pool.swim",
        "figure.rolling",
        "figure.skiing.crosscountry",
        "figure.yoga",
        "dumbbell.fill",
        "bicycle",
        "heart.circle.fill"
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
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 15) {
                                ForEach(icons, id: \.self) { icon in
                                    Button(action: {
                                        selectedIcon = icon
                                    }) {
                                        VStack {
                                            Image(systemName: icon)
                                                .font(.system(size: 30))
                                                .frame(width: 60, height: 60)
                                                .background(selectedIcon == icon ? Color.gray.opacity(0.2) : Color.clear)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                    .foregroundColor(.black)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    
                    Button(action: {
                        if !exerciseName.isEmpty {
                            let newExercise = Exercise(
                                name: exerciseName,
                                duration: duration.isEmpty ? "15 Mins" : duration,
                                icon: selectedIcon
                            )
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





