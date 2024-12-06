//
//  LoginView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-27.
//
import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordHidden: Bool = true
    @State private var isLoggedIn: Bool = false
    @State private var signUp: Bool = false
    @State private var resetPassword: Bool = false
    @State private var errorMessage: String? = nil
    @State private var show2FA: Bool = false
    @State private var is2FASuccess: Bool = false

    // Hardcoded credentials
    private let hardcodedEmail = "ilovecpsc481@ucalgary.ca"
    private let hardcodedPassword = "RoyIsTheBest4ever"

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
                    Image("AppLogo") // Add Icon
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .offset(x: 0, y: 20)
                        .padding(.bottom, 20)

                    // Title
                    Text("Log in to LiftLog")
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
                            } else {
                                TextField("Enter your password", text: $password)
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
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.bottom, 10)
                    }

                    // Login Button
                    Button(action: {
                        validateCredentials()
                    }) {
                        HStack {
                            Spacer()
                            Text("Login")
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
                    .padding(.bottom, 10)
                    .padding(.horizontal, 12)

                    // Sign Up and Forgot Password
                    HStack {
                        Text("Don’t have an account?")
                            .font(.body)
                            .foregroundColor(.gray)
                        NavigationLink(destination: SignupView(), isActive: $signUp) {
                            Button(action: {
                                signUp = true
                            }) {
                                Text("Sign up")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.orange)
                            }
                        }
                        .padding(.bottom, 5)
                    }
                    NavigationLink(destination: ResetPasswordView(), isActive: $resetPassword) {
                        Button(action: {
                            resetPassword = true
                        }) {
                            Text("Forgot Password")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(Color.orange)
                        }
                    }

                    Spacer()
                }
                .padding()

                // Show 2FA Modal
                if show2FA {
                    TwoFactorAuthView(is2FASuccess: $is2FASuccess, show2FA: $show2FA)
                        .transition(.scale)
                        .zIndex(1) // Ensure it appears on top
                }
            }
        }
        .navigationBarBackButtonHidden(true) // Hides the back arrow
        .fullScreenCover(isPresented: $isLoggedIn) {
            ContentView() // Main App View
        }
        .onChange(of: is2FASuccess) { success in
            if success {
                isLoggedIn = true
            }
        }
    }

    // Function to validate credentials
    private func validateCredentials() {
        if email.lowercased() == hardcodedEmail.lowercased() && password == hardcodedPassword {
            errorMessage = nil
            show2FA = true // Show 2FA screen
        } else {
            errorMessage = "Invalid email or password. Please try again."
        }
    }
}

struct TwoFactorAuthView: View {
    @Binding var is2FASuccess: Bool
    @Binding var show2FA: Bool
    @State private var enteredCode: String = ""
    @State private var errorMessage: String? = nil

    // Hardcoded 2FA code
    private let twoFACode = "3142"

    var body: some View {
        VStack(spacing: 20) {
            Text("Two-Factor Authentication")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)

            Text("A code has been sent to your phone. Please enter it below.")
                .font(.body)
                .multilineTextAlignment(.center)

            TextField("Enter 2FA code", text: $enteredCode)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button(action: validate2FA) {
                Text("Verify")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }

            Button(action: {
                show2FA = false // Dismiss modal
            }) {
                Text("Cancel")
                    .font(.body)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding()
    }

    private func validate2FA() {
        if enteredCode == twoFACode {
            is2FASuccess = true
            show2FA = false
        } else {
            errorMessage = "Invalid code. Please try again."
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
