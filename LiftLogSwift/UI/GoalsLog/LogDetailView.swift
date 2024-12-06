//
//  LogDetailView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-12-06.
//

import SwiftUI

struct LogDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let session: WorkoutSession
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(session.routineName)
                                .font(.title)
                                .bold()
                            Text(formatDate(session.date))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        // Stats
                        VStack(alignment: .trailing, spacing: 8) {
                            HStack(spacing: 4) {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.orange)
                                Text("\(Int(session.duration / 60)) min")
                            }
                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(.orange)
                                Text("\(session.totalCalories) kcal")
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .gray.opacity(0.1), radius: 5)
                    
                    // Exercises
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Exercises")
                            .font(.title2)
                            .bold()
                        
                        ForEach(session.exercises) { exercise in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: exercise.icon)
                                        .font(.title2)
                                        .foregroundColor(.orange)
                                        .frame(width: 40)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(exercise.name)
                                            .font(.headline)
                                        Text("\(exercise.sets.count) sets")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                // Sets detail
                                ForEach(exercise.sets.indices, id: \.self) { index in
                                    HStack {
                                        Text("Set \(index + 1)")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        if let reps = exercise.sets[index].reps {
                                            Text("\(reps) reps")
                                        }
                                        if let weight = exercise.sets[index].weight {
                                            Text("•")
                                                .foregroundColor(.gray)
                                            Text("\(Int(weight)) lbs")
                                        }
                                    }
                                    .font(.subheadline)
                                    .padding(.leading)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: .gray.opacity(0.1), radius: 5)
                        }
                    }
                }
                .padding()
            }
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
