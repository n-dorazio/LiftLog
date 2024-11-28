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
    
    var body: some View {
        NavigationView(){
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
                    Image("icon") //Add Icon
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
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
                    
                    // Login Button
                    NavigationLink(destination: ContentView(), isActive: $isLoggedIn){
                        Button(action: {
                            isLoggedIn=true
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
                    }
                    
                    // Sign Up and Forgot Password
                    HStack {
                        Text("Don’t have an account?")
                            .font(.body)
                            .foregroundColor(.gray)
                        NavigationLink(destination: SignupView(),isActive: $signUp){
                            Button(action: {
                                signUp=true
                            }) {
                                Text("Sign up")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.orange)
                            }
                        }
                        .padding(.bottom, 5)
                    }
                    NavigationLink(destination: ResetPasswordView(), isActive: $resetPassword){
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
            }
            
        }
        .navigationBarBackButtonHidden(true) //Hides the back arrow
    }
}





struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
