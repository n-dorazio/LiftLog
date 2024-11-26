//
//  WorkoutSessionView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI

struct WorkoutSessionView: View {
    let routine: Routine
    let exercise: Exercise
    @Environment(\.presentationMode) var presentationMode
    @State private var timeRemaining = 5
    @State private var isCountingDown = true
    @State private var sets: [Set] = [Set(reps: "", weight: "")]
    @State private var showSkipAlert = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                if isCountingDown {
                    // Countdown View
                    VStack(spacing: 20) {
                        Text("GET READY!")
                            .font(.system(size: 40, weight: .bold))
                        
                        Text("\(timeRemaining)")
                            .font(.system(size: 80, weight: .bold))
                        
                        Text(exercise.name)
                            .font(.title)
                            .bold()
                        
                        Image(systemName: exercise.icon)
                            .font(.system(size: 100))
                            .padding(.top, 30)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "clock")
                                Text("\(exercise.duration)")
                            }
                            HStack {
                                Image(systemName: "flame")
                                Text("\(exercise.calories)")
                            }
                            HStack {
                                Image(systemName: "figure.run")
                                Text("4 Sets")
                            }
                        }
                        .padding(.top, 30)
                    }
                } else {
                    // Updated Exercise Tracking View
                    VStack(spacing: 20) {
                        Text(exercise.name)
                            .font(.title)
                            .bold()
                        
                        Image(systemName: exercise.icon)
                            .font(.system(size: 80))
                        
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
                        
                        Button(action: {
                            showSkipAlert = true
                        }) {
                            Text("Skip")
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
                Text("Skip Exercise?")
                    .font(.title2)
                    .bold()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    showSkipAlert = false
                }) {
                    Text("Confirm")
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

