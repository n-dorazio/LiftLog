//
//  LogView.swift

//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-21.
//

import SwiftUI

struct LogView: View {
    @State private var selectedTab = "Goals"
    @State var goals: [Goal] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Picker("View Selection", selection: $selectedTab) {
                    Text("Goals").tag("Goals")
                    Text("My Lift Log").tag("My Lift Log")
                }
                .pickerStyle(.segmented)
                .padding()
                
                if selectedTab == "Goals" {
                    GoalsContent(goals: $goals)
                } else {
                    LogContentView()
                }
                
                Spacer()
            }
            .navigationBarTitle(selectedTab, displayMode: .inline)
        }
    }
}

struct GoalsContent: View {
    @State private var showAddGoal = false
    @Binding public var goals: [Goal]
    
    var body: some View {
        List {
            if goals.isEmpty {
                Text("No goals yet")
                    .foregroundColor(.gray)
                    .padding(.top, 40)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(goals) { goal in
                    GoalCard(goal: goal, goals: $goals)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                if let index = goals.firstIndex(where: { $0.id == goal.id }) {
                                    goals.remove(at: index)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarItems(trailing: Button(action: {
            showAddGoal = true
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
        .sheet(isPresented: $showAddGoal) {
            AddGoalView(goals: $goals)
        }
    }
}

#Preview {
    LogView()
}


