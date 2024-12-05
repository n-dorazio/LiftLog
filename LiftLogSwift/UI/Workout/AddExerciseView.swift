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
    @State private var exerciseName: String
    @State private var duration: String
    @State private var selectedIcon: String
    @State private var isIconGridExpanded = false
    let editMode: Bool
    let exerciseId: UUID?
    
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
    
    init(routineStore: RoutineStore, routine: Binding<Routine>, exercise: Exercise? = nil) {
        self.routineStore = routineStore
        self._routine = routine
        self.editMode = exercise != nil
        self.exerciseId = exercise?.id
        _exerciseName = State(initialValue: exercise?.name ?? "")
        _selectedIcon = State(initialValue: exercise?.icon ?? "figure.strengthtraining.traditional")
        
        // Extract minutes from duration string
        if let exercise = exercise {
            let durationParts = exercise.duration.split(separator: " ")
            _duration = State(initialValue: String(durationParts[0]))
        } else {
            _duration = State(initialValue: "")
        }
    }
    
    private func saveExercise() {
        if !exerciseName.isEmpty && !duration.isEmpty {
            let exercise = Exercise(
                id: exerciseId ?? UUID(),
                name: exerciseName,
                duration: "\(duration) Mins",
                icon: selectedIcon
            )
            
            if editMode {
                if let index = routine.exercises.firstIndex(where: { $0.id == exercise.id }) {
                    routine.exercises[index] = exercise
                    routineStore.updateRoutine(routine)
                }
            } else {
                routine.exercises.append(exercise)
                routineStore.updateRoutine(routine)
            }
            presentationMode.wrappedValue.dismiss()
        }
    }
    
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
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                    
                    // Duration Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Duration (minutes)")
                            .font(.title2)
                            .bold()
                        TextField("Enter duration", text: $duration)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                    
                    // Icon Selection
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Icon")
                                .font(.title2)
                                .bold()
                            Spacer()
                            Button(action: { isIconGridExpanded.toggle() }) {
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
                                        isIconGridExpanded = false
                                    }) {
                                        Image(systemName: icon)
                                            .font(.system(size: 30))
                                            .frame(width: 60, height: 60)
                                            .background(selectedIcon == icon ? Color.orange.opacity(0.2) : Color.clear)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                            }
                        }
                        
                        // Selected Icon Preview
                        HStack {
                            Image(systemName: selectedIcon)
                                .font(.system(size: 30))
                                .foregroundColor(.orange)
                                .frame(width: 60, height: 60)
                                .background(Color.orange.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            Text("Selected Icon")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(editMode ? "Edit Exercise" : "Add Exercise")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button(editMode ? "Save" : "Add") {
                    saveExercise()
                }
                .disabled(exerciseName.isEmpty || duration.isEmpty)
            )
        }
    }
}





