//
//  EditWeightView.swift
//  LiftLogSwift
//
//  Created by Luke CHEN on 2024-11-22.
//

//
//  SettingsView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI

struct EditWeightView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userProfile: UserProfileModel
    @State private var weight = "140 lbs"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Profile Image
                    VStack(spacing: 8) {
                        Button(action: {})
                        {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "pencil.circle.fill")
                                        .foregroundColor(.blue)
                                        .offset(x: 35, y: 35)
                                )
                        }
                        
                        Text("Jane Doe")
                            .font(.title2)
                            .bold()
                    }
                    .padding(.bottom)
                    
                    VStack(spacing: 12) {
                        Text("Settings")
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationBarHidden(true)
        }
    }
}


