//
//  WorkoutSessionView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI
import Combine

struct WorkoutSessionView: View {
    let routine: Routine
    let initialExerciseIndex: Int
    @State private var currentExerciseIndex: Int
    @Environment(\.presentationMode) var presentationMode
    @State private var timeRemaining = 5
    @State private var isCountingDown = false
    @State private var showStartPrompt = true
    @State private var sets: [Set] = [Set(reps: "", weight: "")]
    @State private var showSkipAlert = false
    @State private var elapsedTime = 0
    @State private var isPaused = false
    
    init(routine: Routine, initialExerciseIndex: Int = 0) {
        self.routine = routine
        self.initialExerciseIndex = initialExerciseIndex
        _currentExerciseIndex = State(initialValue: initialExerciseIndex)
    }
    
    var currentExercise: Exercise {
        routine.exercises[currentExerciseIndex]
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
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
                        
                        Text("\(timeRemaining)")
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
                        Text(formatTime(elapsedTime))
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
                                        get: { sets[index].reps },
                                        set: { sets[index].reps = $0 }
                                    ))
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: .infinity)
                                    
                                    TextField("0", text: Binding(
                                        get: { sets[index].weight },
                                        set: { sets[index].weight = $0 }
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
                        
                        if currentExerciseIndex < routine.exercises.count - 1 {
                            Button(action: {
                                showSkipAlert = true
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
                            presentationMode.wrappedValue.dismiss()
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
                        currentExerciseIndex += 1
                        timeRemaining = 5
                        showStartPrompt = true
                        isCountingDown = false
                        sets = [Set(reps: "", weight: "")]
                        elapsedTime = 0
                        isPaused = false
                    } else {
                        presentationMode.wrappedValue.dismiss()
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
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    isCountingDown = false
                }
            } else if !isPaused {
                elapsedTime += 1
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

