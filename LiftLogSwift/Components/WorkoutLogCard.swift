//
//  WorkoutLogCard.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-12-03.
//

import SwiftUI

struct WorkoutLogCard: View {
    let session: WorkoutSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.routineName)
                        .font(.title2)
                        .bold()
                    Text(formatDate(session.date))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(formatDuration(session.duration))
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            
            // Exercise List
            VStack(spacing: 12) {
                ForEach(session.exercises) { exercise in
                    ExerciseLogRow(exercise: exercise)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.1), radius: 10)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        return "\(minutes) min"
    }
}

struct ExerciseLogRow: View {
    let exercise: WorkoutSession.ExerciseSession
    
    var body: some View {
        HStack {
            Image(systemName: exercise.icon)
                .font(.title3)
                .foregroundColor(.gray)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.headline)
                Text(formatSets(exercise.sets))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func formatSets(_ sets: [WorkoutSession.ExerciseSession.SetData]) -> String {
        "\(sets.count) sets • \(sets.map { "\($0.reps)×\(Int($0.weight))lbs" }.joined(separator: ", "))"
    }
}
