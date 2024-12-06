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
    @State private var showTermsPopup: Bool = false
    @State private var agreeToTerms: Bool = false
    @State private var isFinishedOnboarding: Bool = false

    var body: some View {
        ZStack {
            NavigationView {
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
                        Button(action: {
                            if !weight.isEmpty && !dob.isEmpty && !workoutDays.isEmpty && !selectedExercise.isEmpty {
                                showTermsPopup = true
                            }
                        }) {
                            HStack {
                                Text("Next")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 120, height: 50)
                            .background(
                                (!weight.isEmpty && !dob.isEmpty && !workoutDays.isEmpty && !selectedExercise.isEmpty)
                                    ? Color.black
                                    : Color.gray
                            )
                            .cornerRadius(25)
                        }
                        .disabled(weight.isEmpty || dob.isEmpty || workoutDays.isEmpty || selectedExercise.isEmpty)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarBackButtonHidden(true) // Hides the back arrow

            // Terms and Conditions Popup
            if showTermsPopup {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Terms and Conditions")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    ScrollView {
                        Text("""
                        By proceeding, you agree to LiftLog's Terms and Conditions and Privacy Policy. Please read them carefully before continuing.
                        """)
                        .font(.body)
                        .padding()
                    }
                    .frame(maxHeight: 200)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    
                    Toggle(isOn: $agreeToTerms) {
                        Text("I agree to the Terms and Conditions and Privacy Policy")
                            .font(.body)
                    }
                    .padding()
                    
                    HStack {
                        Button(action: {
                            showTermsPopup = false
                        }) {
                            Text("Cancel")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            if agreeToTerms {
                                isFinishedOnboarding = true
                            }
                        }) {
                            Text("Agree")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(agreeToTerms ? Color.black : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(!agreeToTerms)
                    }
                    .padding()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 10)
                .padding(.horizontal, 20)
            }
        }
        .fullScreenCover(isPresented: $isFinishedOnboarding) {
            ContentView() // Replace with your main app's next screen
        }
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

struct RadioButtonForOnboarding2: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.black)
            Spacer()
            Button(action: action) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .orange : .gray)
                    .font(.system(size: 20))
            }
        }
        .padding()
        .padding(.horizontal, 16)
        .background(isSelected ? Color.orange.opacity(0.5) : Color.gray.opacity(0.2))
        .cornerRadius(24)
    }
}

struct Onboarding2_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen2()
    }
}
