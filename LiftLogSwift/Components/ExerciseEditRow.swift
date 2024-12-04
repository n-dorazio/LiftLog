//
//  ExerciseEditRow.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-12-03.
//

import SwiftUI

struct ExerciseEditRow: View {
    @Binding var exercise: WorkoutSession.ExerciseSession
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: exercise.icon)
                    .font(.title3)
                    .foregroundColor(.gray)
                    .frame(width: 30)
                
                TextField("Exercise name", text: $exercise.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            ForEach($exercise.sets) { $set in
                HStack {
                    TextField("Reps", value: $set.reps, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: .infinity)
                    
                    TextField("Weight", value: $set.weight, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
