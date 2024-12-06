//
//  EditWeightView.swift
//  LiftLogSwift
//
//  Created by Luke CHEN on 2024-11-22.
//

import SwiftUI

struct EditWeightView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var settings: SettingsStore
    @State private var weightInput: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .padding(10)
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Cancel changes
                }) {
                    Text("Cancel")
                        .foregroundColor(.red)
                        .bold()
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Main Content
            Text("Edit Weight")
                .font(.title)
                .bold()
                .padding()
            
            TextField("Enter your weight", text: $weightInput)
                .keyboardType(.numberPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                settings.weight = weightInput
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
        .onAppear {
            weightInput = settings.weight
        }
    }
}

