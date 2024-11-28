//
//  PasswordSentView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-27.
//

import SwiftUI

struct PasswordSentView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
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
                .frame(height:500)
                .offset(y:-50)
            
            VStack(spacing: 30) {
                Spacer()
                
                // Confirmation Icon
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                
                // Title
                Text("Password Sent!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                // Description
                Text("""
                We’ve sent a password reset link to jo***oe@gmail.com.
                Resend if the link is not received!
                """)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                
                // Resend Password Button
                Button(action: {
                    // Handle resend action
                }) {
                    HStack {
                        Text("Re-Send Password")
                            .font(.headline)
                            .foregroundColor(.white)
                        Image(systemName: "lock")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black)
                    .cornerRadius(12)
                }
                
                Spacer()
                
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .padding(.bottom, 20)
                    .offset(y:-60)
                }
                .padding()
        }
        .navigationBarBackButtonHidden(true) //Hides the back arrow
    }
}

struct PasswordSentView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordSentView()
    }
}

