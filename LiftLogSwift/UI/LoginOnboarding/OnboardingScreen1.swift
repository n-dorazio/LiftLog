//
//  OnboardingScreen1.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-27.
//

import SwiftUI

struct OnboardingScreen1: View {
    @State private var selectedGoal: String = ""
    @State private var selectedGender: String = ""
    @State private var showNextScreen: Bool = false

    var body: some View {
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
                    // App Icon
                    Image("AppLogo") //Add Icon
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .offset(x:0, y:20)
                        .padding(.bottom, 20)
                    // Title
                    Text("Welcome to LiftLog!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)

                    Text("Let’s personalize your fitness!")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)

                    // Fitness Goal Options
                    Text("What is your fitness goal?")
                        .font(.headline)
                        .padding(.bottom, 10)

                    VStack(spacing: 10) {
                        RadioButton(title: "I want to lose weight", isSelected: selectedGoal == "Lose Weight") {
                            selectedGoal = "Lose Weight"
                        }
                        RadioButton(title: "I want to bulk", isSelected: selectedGoal == "Bulk") {
                            selectedGoal = "Bulk"
                        }
                        RadioButton(title: "I want to gain endurance", isSelected: selectedGoal == "Endurance") {
                            selectedGoal = "Endurance"
                        }
                        RadioButton(title: "Just trying out the app! 👍", isSelected: selectedGoal == "Try Out") {
                            selectedGoal = "Try Out"
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)

                    // Gender Options
                    Text("What is your gender?")
                        .font(.headline)
                        .padding(.bottom, 10)

                    VStack(spacing: 10) {
                        RadioButton(title: "Male", isSelected: selectedGender == "Male") {
                            selectedGender = "Male"
                        }
                        RadioButton(title: "Female", isSelected: selectedGender == "Female") {
                            selectedGender = "Female"
                        }
                    }

                    Spacer()

                    // Next Button
                    NavigationLink(destination: OnboardingScreen2(), isActive: $showNextScreen) {
                        Button(action: {
                            showNextScreen = true
                        }) {
                            Image(systemName: "arrow.right")
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.bottom, 20)
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true) //Hides the back arrow
    }
}

// RadioButton Component
struct RadioButton: View {
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


struct Onboarding1_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen1()
    }
}
