//
//  LogContentView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-12-03.
//

import SwiftUI

struct LogContentView: View {
    @StateObject private var workoutStore = WorkoutStore()
    @State private var showAddWorkout = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(workoutStore.sessions) { session in
                    WorkoutLogCard(session: session)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                workoutStore.deleteSession(session.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .padding()
        }
        .navigationBarItems(
            trailing: Button(action: {
                showAddWorkout = true
            }) {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.orange, .red]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
            }
        )
        .sheet(isPresented: $showAddWorkout) {
            AddWorkoutLogView(workoutStore: workoutStore)
        }
    }
}
