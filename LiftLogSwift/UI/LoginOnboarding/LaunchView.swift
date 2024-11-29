//
//  LaunchView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-27.
//

import SwiftUI


struct LaunchView: View{
    
    @State private var isClicked: Bool = false
    @State private var signUp: Bool = false
    
    var body: some View{
        NavigationView{
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.orange, Color.red]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                VStack{
                    Spacer()
                    Image("AppLogo") //Add Icon
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.bottom, 20)
                    
                    Text("FIND OUT WHAT DIET & TRAINING WILL WORK SPECIFICALLY FOR YOU")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    
                    NavigationLink(destination: LoginView(), isActive: $isClicked){
                        Button(action: {
                            isClicked=true
                        }) {
                            HStack (spacing: 30){
                                Text("Login")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                //Spacer()
                                //Image(systemName: "arrow.right")
                                  //.foregroundColor(.black)
                            }
                            .padding()
                            .padding(.horizontal, 16)
                            .background(Color.white)
                            .cornerRadius(8)
                        }
                        .padding(.bottom, 10)
                        .padding(.horizontal, 12)
                    }
                    Spacer()
                    
                    Button(action:{
                        
                    }){
                        HStack(alignment: .center) {
                            Image(systemName: "arrow.right")//Change to Google Logo
                                .foregroundColor(.white)
                            Text("Login with Google")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .padding(.horizontal, 80)
                        .background(Color.black)
                        .cornerRadius(32)
                    }
                    .padding(.bottom, 10)
                    .padding(.horizontal, 12)
                    
                    
                    Button(action:{
                        
                    }){
                        HStack(alignment: .center) {
                            Image(systemName: "arrow.right")//Change to Apple Logo
                                .foregroundColor(.white)
                            
                            Text("Login with Apple")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .padding(.horizontal, 80)
                        .background(Color.black)
                        .cornerRadius(32)
                    }
                    .padding(.bottom, 10)
                    .padding(.horizontal, 12)
                    
                    
                    
                    // Sign Up and Forgot Password
                    HStack {
                        Text("Don’t have an account?")
                            .font(.body)
                            .foregroundColor(.black)
                        NavigationLink(destination: SignupView(), isActive: $signUp){
                            Button(action: {
                                signUp=true
                            }) {
                                Text("Sign up")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                            }
                            
                        }
                        .padding(.bottom, 5)
                    }
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
