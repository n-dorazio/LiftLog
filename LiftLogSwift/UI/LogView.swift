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
                // Custom Tab Picker
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
        ScrollView {
            VStack(spacing: 20) {
                // Add Button
                HStack {
                    Spacer()
                    Button(action: {
                        showAddGoal = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Circle().fill(Color.gray.opacity(0.1)))
                    }
                }
                .padding(.horizontal)
                .sheet(isPresented: $showAddGoal) {
                    AddGoalView(goals: $goals)
                }
                
                // Goals List
                if goals.isEmpty {
                    Text("No goals yet")
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                } else {
                    ForEach(goals) { goal in
                        GoalCard(goal: goal)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    LogView()
}


