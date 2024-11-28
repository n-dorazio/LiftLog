//
//  OnboardingScreen2.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-27.
//

import SwiftUI

struct OnboardingScreen2: View {
    @State private var weight: String = ""
    @State private var dob: String = ""
    @State private var workoutDays: String = ""
    @State private var selectedExercise: String = ""
    @State private var isFinishedOnboarding: Bool = false

    var body: some View {
        NavigationView{
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.orange, Color.red]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // White Rectangle in the Background
                Rectangle()
                    .fill(Color.white.opacity(0.8))
                    .cornerRadius(24)
                    .padding()
                
                VStack {
                    // Questions
                    Spacer()
                    VStack(alignment: .leading, spacing: 20) {
                        TextFieldWithTitle(title: "What is your weight?", placeholder: "In kgs...", text: $weight)
                        TextFieldWithTitle(title: "What is your date of birth? (YYYYMMDD)", placeholder: "YYYYMMDD", text: $dob)
                        TextFieldWithTitle(title: "How many days/week you plan to workout?", placeholder: "In days...", text: $workoutDays)
                        
                        // Exercise Preferences
                        Text("Do you have an exercise preference?")
                            .font(.headline)
                            .padding(.bottom, 10)
                        
                        VStack(spacing: 10) {
                            RadioButton(title: "Weightlift", isSelected: selectedExercise == "Weightlift") {
                                selectedExercise = "Weightlift"
                            }
                            RadioButton(title: "Cardio", isSelected: selectedExercise == "Cardio") {
                                selectedExercise = "Cardio"
                            }
                            RadioButton(title: "Yoga", isSelected: selectedExercise == "Yoga") {
                                selectedExercise = "Yoga"
                            }
                            RadioButton(title: "Other", isSelected: selectedExercise == "Other") {
                                selectedExercise = "Other"
                            }
                        }
                    }
                    .padding()
                    .padding(.horizontal, 16)
                    
                    Spacer()
                    
                    // Next Button
                    NavigationLink(destination: ContentView(), isActive: $isFinishedOnboarding){
                        Button(action: {
                            isFinishedOnboarding=true
                        }) {
                            Image(systemName: "arrow.right")
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                        .padding(.bottom, 20)
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true) //Hides the back arrow
    }
}

// TextFieldWithTitle Component
struct TextFieldWithTitle: View {
    let title: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
            TextField(placeholder, text: $text)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
    }
}


struct Onboarding2_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen2()
    }
}
