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
    @State private var showEndWorkoutAlert = false
    @State private var showNextExerciseAlert = false
    @State private var showHydrationReminder = false
    @State private var lastHydrationReminder = Date()
    @State private var showNextExerciseSheet = false
    
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
                    ExercisePreviewSheet(
                        exercise: currentExercise,
                        buttonText: "Begin Exercise",
                        buttonAction: {
                            showStartPrompt = false
                            isCountingDown = true
                        },
                        showCancelButton: false,
                        onCancel: {}
                    )
                } else if isCountingDown {
                    VStack(spacing: 20) {
                        // Header with exercise name and icon
                        VStack(spacing: 15) {
                            Text("GET READY!")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.orange)
                            
                            Text(currentExercise.name)
                                .font(.system(size: 24, weight: .bold))
                                .multilineTextAlignment(.center)
                            
                            Image(systemName: currentExercise.icon)
                                .font(.system(size: 60))
                                .foregroundColor(.orange)
                                .padding()
                                .background(
                                    Circle()
                                        .fill(Color.orange.opacity(0.2))
                                        .frame(width: 120, height: 120)
                                )
                        }
                        .padding(.top, 20)
                        
                        // Countdown timer card
                        VStack(spacing: 15) {
                            Text("\(exerciseTimeRemaining)")
                                .font(.system(size: 80, weight: .bold))
                                .monospacedDigit()
                                .foregroundColor(.orange)
                                .frame(width: 150, height: 150)
                                .background(
                                    Circle()
                                        .fill(Color.orange.opacity(0.1))
                                )
                            
                            // Exercise info
                            HStack(spacing: 30) {
                                VStack {
                                    Image(systemName: "clock.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(.orange)
                                    Text(currentExercise.duration)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                VStack {
                                    Image(systemName: "flame.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(.orange)
                                    Text(currentExercise.calories)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 30)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: .gray.opacity(0.2), radius: 10)
                        )
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        // Skip button
                        Button(action: {
                            isCountingDown = false
                            exerciseTimeRemaining = 0
                        }) {
                            HStack {
                                Text("Skip")
                                    .font(.title3)
                                    .bold()
                                Image(systemName: "forward.fill")
                                    .font(.title3)
                            }
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
                        .padding(.horizontal)
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
                                showNextExerciseSheet = true
                            }) {
                                HStack {
                                    Text("Next Exercise")
                                        .font(.title3)
                                        .bold()
                                    Image(systemName: "arrow.right")
                                        .font(.title3)
                                }
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
                            .padding(.horizontal)
                            .sheet(isPresented: $showNextExerciseSheet) {
                                ExercisePreviewSheet(
                                    exercise: routine.exercises[currentExerciseIndex + 1],
                                    buttonText: "Begin Next Exercise",
                                    buttonAction: {
                                        saveCurrentExercise()
                                        currentExerciseIndex += 1
                                        exerciseTimeRemaining = 5
                                        showStartPrompt = false
                                        isCountingDown = true
                                        sets = [Set(reps: "", weight: "")]
                                        isPaused = false
                                        showNextExerciseSheet = false
                                    },
                                    showCancelButton: true,
                                    onCancel: { showNextExerciseSheet = false }
                                )
                            }
                        }
                        
                        Button(action: {
                            showEndWorkoutAlert = true
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
                        .alert("End Workout?", isPresented: $showEndWorkoutAlert) {
                            Button("Cancel", role: .cancel) { }
                            Button("End Workout", role: .destructive) {
                                saveCurrentExercise()
                                finishWorkout()
                            }
                        } message: {
                            Text("Are you sure you want to end this workout? \nThis action cannot be undone.")
                        }
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
                
                // Show hydration reminder every 30 seconds (for testing)
                if workoutDuration % 30 == 0 && workoutDuration > 0 {
                    showHydrationReminder = true
                }
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
        .alert("Reminder to Hydrate 💧", isPresented: $showHydrationReminder) {
            Button("Done") {
                showHydrationReminder = false
            }
        } message: {
            Text("Don't forget to drink water in between sets!")
        }
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct ExercisePreviewSheet: View {
    let exercise: Exercise
    let buttonText: String
    let buttonAction: () -> Void
    let showCancelButton: Bool
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            // Header with exercise name and icon
            VStack(spacing: 12) {
                Text(exercise.name)
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Image(systemName: exercise.icon)
                    .font(.system(size: 45))
                    .foregroundColor(.orange)
                    .padding()
                    .background(
                        Circle()
                            .fill(Color.orange.opacity(0.2))
                            .frame(width: 90, height: 90)
                    )
            }
            .padding(.top, 15)
            
            // Exercise details card
            VStack(spacing: 12) {
                HStack(spacing: 25) {
                    // Duration info
                    VStack {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.orange)
                        Text(exercise.duration)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    // Calories info
                    VStack {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.orange)
                        Text(exercise.calories)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    // Sets info
                    VStack {
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.system(size: 20))
                            .foregroundColor(.orange)
                        Text("4 Sets")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                // Target Muscles
                VStack(spacing: 8) {
                    Text("Target Muscles")
                        .font(.headline)
                        .foregroundColor(.gray)
                    HStack(spacing: 10) {
                        ForEach(["Quads", "Glutes", "Core"], id: \.self) { muscle in
                            Text(muscle)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(15)
                        }
                    }
                }
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.2), radius: 8)
            )
            .padding(.horizontal)
            
            // Buttons
            VStack(spacing: 10) {
                Button(action: buttonAction) {
                    HStack {
                        Text(buttonText)
                            .font(.title3)
                            .bold()
                        Image(systemName: "arrow.right")
                            .font(.title3)
                    }
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
                    .cornerRadius(15)
                }
                
                if showCancelButton {
                    Button(action: onCancel) {
                        Text("Cancel")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .foregroundColor(.gray)
                            .cornerRadius(15)
                    }
                }
            }
            .padding(.horizontal)
        }
        .presentationDetents([.height(500)])
    }
}

