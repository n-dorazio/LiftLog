//
//  WorkoutSessionView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI
import Combine

struct WorkoutSessionView: View {
    @ObservedObject var workoutStore: WorkoutStore
    let routine: Routine
    let initialExerciseIndex: Int
    @Environment(\.presentationMode) var presentationMode
    @State private var currentExerciseIndex: Int
    @State private var workoutDuration = 0
    @State private var exerciseTimeRemaining = 5
    @State private var isCountingDown = false
    @State private var showStartPrompt = true
    @State private var sets: [Set] = [Set(reps: "", weight: "")]
    @State private var elapsedTime = 0
    @State private var isPaused = false
    @State private var showSkipAlert = false
    @State private var completedExercises: [WorkoutSession.ExerciseSession] = []
    
    struct Set: Identifiable {
        let id = UUID()
        var reps: String
        var weight: String
    }
    
    init(workoutStore: WorkoutStore, routine: Routine, initialExerciseIndex: Int = 0) {
        self.workoutStore = workoutStore
        self.routine = routine
        self.initialExerciseIndex = initialExerciseIndex
        _currentExerciseIndex = State(initialValue: initialExerciseIndex)
    }
    
    var currentExercise: Exercise {
        guard currentExerciseIndex < routine.exercises.count else {
            // If we somehow get an invalid index, finish the workout
            finishWorkout()
            return routine.exercises[routine.exercises.count - 1] // Return last exercise as fallback
        }
        return routine.exercises[currentExerciseIndex]
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    private func saveCurrentExercise() {
        let exercise = currentExercise
        let exerciseSession = WorkoutSession.ExerciseSession(
            id: UUID(),
            name: exercise.name,
            icon: exercise.icon,
            sets: sets.compactMap { set in
                guard let reps = Int(set.reps),
                      let weight = Double(set.weight) else { return nil }
                return WorkoutSession.ExerciseSession.SetData(
                    reps: reps,
                    weight: weight
                )
            }
        )
        completedExercises.append(exerciseSession)
    }
    
    private func finishWorkout() {
        // Make sure the last exercise is saved
        if !completedExercises.contains(where: { $0.name == currentExercise.name }) {
            saveCurrentExercise()
        }
        
        let session = WorkoutSession(
            id: UUID(),
            routineName: routine.name,
            date: Date(),
            duration: TimeInterval(workoutDuration),
            totalCalories: completedExercises.reduce(0) { total, exercise in
                total + (exercise.sets.count * 50) // 50 calories per set as an example
            },
            exercises: completedExercises
        )
        
        workoutStore.addSession(session)
        presentationMode.wrappedValue.dismiss()
    }
    
    var isLastExercise: Bool {
        currentExerciseIndex == routine.exercises.count - 1
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                if showStartPrompt {
                    VStack(spacing: 20) {
                        Text(currentExercise.name)
                            .font(.title)
                            .bold()
                        
                        Image(systemName: currentExercise.icon)
                            .font(.system(size: 100))
                            .padding(.top, 30)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "clock")
                                Text(currentExercise.duration)
                            }
                            HStack {
                                Image(systemName: "flame")
                                Text(currentExercise.calories)
                            }
                        }
                        .padding(.top, 30)
                        
                        Spacer()
                        
                        Button(action: {
                            showStartPrompt = false
                            isCountingDown = true
                        }) {
                            Text("Begin Exercise")
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
                        .padding(.horizontal)
                    }
                } else if isCountingDown {
                    // Countdown View
                    VStack(spacing: 20) {
                        Text("GET READY!")
                            .font(.system(size: 40, weight: .bold))
                        
                        Text("\(exerciseTimeRemaining)")
                            .font(.system(size: 80, weight: .bold))
                        
                        Text(currentExercise.name)
                            .font(.title)
                            .bold()
                        
                        Image(systemName: currentExercise.icon)
                            .font(.system(size: 100))
                            .padding(.top, 30)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "clock")
                                Text("\(currentExercise.duration)")
                            }
                            HStack {
                                Image(systemName: "flame")
                                Text("\(currentExercise.calories)")
                            }
                            HStack {
                                Image(systemName: "figure.run")
                                Text("4 Sets")
                            }
                        }
                        .padding(.top, 30)
                    }
                } else {
                    VStack(spacing: 20) {
                        Text(currentExercise.name)
                            .font(.title)
                            .bold()
                        
                        // Timer Display
                        Text(formatTime(workoutDuration))
                            .font(.system(size: 40, weight: .bold))
                            .monospacedDigit()
                        
                        // Pause/Resume Button
                        Button(action: {
                            isPaused.toggle()
                        }) {
                            Image(systemName: isPaused ? "play.circle.fill" : "pause.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.orange)
                        }
                        
                        // Sets tracking
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Sets")
                                    .font(.title2)
                                    .bold()
                                Text("Reps")
                                    .font(.title2)
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                Text("Weight")
                                    .font(.title2)
                                    .bold()
                                    .frame(maxWidth: .infinity)
                            }
                            .padding(.horizontal)
                            
                            ForEach(Array(sets.enumerated()), id: \.element.id) { index, set in
                                HStack {
                                    Text("\(index + 1)")
                                        .font(.title2)
                                        .bold()
                                        .frame(width: 40)
                                    
                                    TextField("0", text: Binding(
                                        get: { self.sets[safe: index]?.reps ?? "" },
                                        set: { newValue in
                                            if index < self.sets.count {
                                                self.sets[index].reps = newValue
                                            }
                                        }
                                    ))
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: .infinity)
                                    
                                    TextField("0", text: Binding(
                                        get: { self.sets[safe: index]?.weight ?? "" },
                                        set: { newValue in
                                            if index < self.sets.count {
                                                self.sets[index].weight = newValue
                                            }
                                        }
                                    ))
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: .infinity)
                                }
                                .padding(.horizontal)
                            }
                            
                            HStack {
                                Button(action: {
                                    sets.append(Set(reps: "", weight: ""))
                                }) {
                                    Text("Add Set")
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
                                
                                Button(action: {
                                    if sets.count > 1 {
                                        sets.removeLast()
                                    }
                                }) {
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
                            .padding()
                        }
                        
                        Spacer()
                        
                        if !isLastExercise {
                            Button(action: {
                                saveCurrentExercise()
                                
                                // Reset states for next exercise
                                currentExerciseIndex += 1
                                exerciseTimeRemaining = 5
                                showStartPrompt = true
                                sets = [Set(reps: "", weight: "")]
                                // Note: We're not resetting workoutDuration here
                                isPaused = false
                                showSkipAlert = false
                            }) {
                                Text("Next Exercise")
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
                            .padding(.horizontal)
                        }
                        
                        Button(action: {
                            saveCurrentExercise()
                            finishWorkout()
                        }) {
                            Text("End Workout")
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
                        .padding(.horizontal)
                    }
                }
            }
        }
        .sheet(isPresented: $showSkipAlert) {
            VStack(spacing: 20) {
                Text("Move to Next Exercise?")
                    .font(.title2)
                    .bold()
                
                Button(action: {
                    if currentExerciseIndex < routine.exercises.count - 1 {
                        saveCurrentExercise()
                        currentExerciseIndex += 1
                        exerciseTimeRemaining = 5
                        showStartPrompt = true
                        isCountingDown = false
                        sets = [Set(reps: "", weight: "")]
                        elapsedTime = 0
                        isPaused = false
                    } else {
                        finishWorkout()
                    }
                    showSkipAlert = false
                }) {
                    Text(currentExerciseIndex < routine.exercises.count - 1 ? "Next Exercise" : "Finish Workout")
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
                .padding(.horizontal)
                
                Button(action: {
                    showSkipAlert = false
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            .padding()
            .presentationDetents([.height(200)])
        }
        .onReceive(timer) { _ in
            if isCountingDown {
                if exerciseTimeRemaining > 0 {
                    exerciseTimeRemaining -= 1
                } else {
                    isCountingDown = false
                }
            } else if !isPaused {
                workoutDuration += 1
            }
        }
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

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

