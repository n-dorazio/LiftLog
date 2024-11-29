//
//  ResetPasswordView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-27.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showPasswordSent: Bool = false // For navigation to the confirmation screen

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
                
                ZStack(alignment: .topLeading){
                    // White Rectangle in the Background
                    Rectangle()
                        .fill(Color.white.opacity(0.8))
                        .cornerRadius(24)
                        .padding()
                        .frame(height:450)
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Go back to the previous screen
                    }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.black)
                            .padding(16)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                    .offset(x:20,y:20)
                    .padding()
                }

                VStack(spacing: 30) {
                    Spacer()
                    // Title
                    Text("Reset Password")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 60)

                    Text("Select what method you’d like to reset.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // Reset Method Option
                    HStack {
                        Image(systemName: "envelope.fill") // Email Icon
                            .foregroundColor(.orange)
                            .frame(width: 40, height: 40)

                        VStack(alignment: .leading) {
                            Text("Send via Email")
                                .font(.headline)
                                .foregroundColor(.black)
                            Text("Seamlessly reset your password via email address.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(24)

                    // Reset Password Button
                    NavigationLink(destination: PasswordSentView(), isActive: $showPasswordSent) {
                        Button(action: {
                            showPasswordSent = true
                        }) {
                            HStack {
                                Spacer()
                                Text("Reset Password")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.black)
                            .cornerRadius(12)
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal,16)
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true) //Hides the back arrow
    }
}


struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
