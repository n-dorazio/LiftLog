//
//  SignupView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-27.
//

import SwiftUI

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isPasswordHidden: Bool = true
    @State private var isLoggedIn: Bool = false
    @State private var isSignedUp: Bool = false
    
    // Validation State
    @State private var errorMessage: String = ""
    @State private var passwordMessage: String = ""
    
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
                
                // Content (Text, Fields, and Buttons)
                VStack {
                    // Top Icon
                    Spacer()
                    Image("AppLogo") // Add Icon
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.bottom, 20)
                    
                    // Title
                    Text("Sign up for FREE")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    
                    Text("Let’s personalize your fitness!")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                    
                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email Address")
                            .font(.headline)
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.black)
                            TextField("Enter your email", text: $email)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .keyboardType(.emailAddress)
                                .submitLabel(.next)
                        }
                        .padding(.horizontal, 16)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                    }
                    .padding(.bottom, 15)
                    .padding(.horizontal, 12)
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.headline)
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                            if isPasswordHidden {
                                SecureField("Enter your password", text: $password)
                                    .onChange(of: password, perform: validatePassword)
                            } else {
                                TextField("Enter your password", text: $password)
                                    .onChange(of: password, perform: validatePassword)
                            }
                            Button(action: {
                                isPasswordHidden.toggle()
                            }) {
                                Image(systemName: isPasswordHidden ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                    }
                    .padding(.bottom, 5)
                    .padding(.horizontal, 12)
                    
                    // Password Requirements Message
                    if !passwordMessage.isEmpty {
                        Text(passwordMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.bottom, 10)
                    }
                    
                    // Confirm Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Confirm Password")
                            .font(.headline)
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                            if isPasswordHidden {
                                SecureField("Confirm your password", text: $confirmPassword)
                            } else {
                                TextField("Confirm your password", text: $confirmPassword)
                            }
                            Button(action: {
                                isPasswordHidden.toggle()
                            }) {
                                Image(systemName: isPasswordHidden ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                    }
                    .padding(.bottom, 15)
                    .padding(.horizontal, 12)
                    
                    // Error Message
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.bottom, 10)
                    }
                    
                    // Sign Up Button
                    NavigationLink(destination: OnboardingScreen1(), isActive: $isLoggedIn) {
                        Button(action: {
                            handleSignup()
                        }) {
                            HStack {
                                Spacer()
                                Text("Sign Up")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .padding(.horizontal, 16)
                            .background(Color.black)
                            .cornerRadius(8)
                        }
                        .disabled(email.isEmpty || password.isEmpty || confirmPassword.isEmpty || !isPasswordValid(password))
                        .opacity(email.isEmpty || password.isEmpty || confirmPassword.isEmpty || !isPasswordValid(password) ? 0.6 : 1.0)
                    }
                    .padding(.bottom, 10)
                    .padding(.horizontal, 12)
                    
                    // Login
                    HStack {
                        Text("Already have an account?")
                            .font(.body)
                            .foregroundColor(.gray)
                        NavigationLink(destination: LoginView(), isActive: $isSignedUp) {
                            Button(action: {
                                isSignedUp = true
                            }) {
                                Text("Login")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.orange)
                            }
                        }
                        .padding(.bottom, 5)
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true) // Hides the back arrow
    }
    
    private func handleSignup() {
        errorMessage = ""
        
        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "Please fill out all fields."
            return
        }
        
        if !isValidEmail(email) {
            errorMessage = "Please enter a valid email address."
            return
        }
        
        if !isPasswordValid(password) {
            errorMessage = "Password must meet requirements."
            return
        }
        
        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            return
        }
        
        // Simulate success (Replace with real backend call)
        isLoggedIn = true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{8,15}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    private func validatePassword(_ password: String) {
        if !isPasswordValid(password) {
            passwordMessage = "Password must be 8-15 characters, include 1 number, and 1 special character."
        } else {
            passwordMessage = ""
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
