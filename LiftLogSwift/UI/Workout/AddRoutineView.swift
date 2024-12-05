//
//  AddRoutineView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI

struct AddRoutineView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var routineStore: RoutineStore
    @State private var routineName = ""
    
    var body: some View {
        VStack(spacing: 24) {
            // Header with close button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding(.horizontal)
            
            Text("Add a new Routine")
                .font(.title2)
                .bold()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Routine Name")
                    .font(.headline)
                
                TextField("New Routine", text: $routineName)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            
            Button(action: {
                if !routineName.isEmpty {
                    routineStore.addRoutine(name: routineName)
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Confirm")
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.red, .orange]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            .padding(.horizontal)
            .disabled(routineName.isEmpty)
            
            Spacer()
        }
        .padding(.top, 20)
        .background(Color.white)
    }
}


