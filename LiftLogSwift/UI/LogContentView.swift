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
    @State private var sortOrder: SortOrder = .newest
    
    enum SortOrder {
        case newest, oldest
        
        var text: String {
            switch self {
            case .newest: return "Newest First"
            case .oldest: return "Oldest First"
            }
        }
        
        var icon: String {
            switch self {
            case .newest: return "arrow.down"
            case .oldest: return "arrow.up"
            }
        }
    }
    
    var sortedSessions: [WorkoutSession] {
        workoutStore.sessions.sorted { 
            sortOrder == .newest ? $0.date > $1.date : $0.date < $1.date
        }
    }
    
    var body: some View {
        List {
            HStack {
                Spacer()
                Menu {
                    Button(action: { sortOrder = .newest }) {
                        Label("Newest First", systemImage: "arrow.down")
                    }
                    Button(action: { sortOrder = .oldest }) {
                        Label("Oldest First", systemImage: "arrow.up")
                    }
                } label: {
                    Label(sortOrder.text, systemImage: sortOrder.icon)
                        .foregroundColor(.gray)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding(.trailing)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            .padding(.vertical, 8)
            
            ForEach(sortedSessions) { session in
                WorkoutLogCard(session: session, workoutStore: workoutStore)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            workoutStore.deleteSession(session.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarItems(trailing: Button(action: {
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
        })
        .sheet(isPresented: $showAddWorkout) {
            AddWorkoutLogView(workoutStore: workoutStore)
        }
    }
}


#Preview {
    LogContentView()
}
