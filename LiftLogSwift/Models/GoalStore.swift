//
//  GoalStore.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import Foundation

class GoalStore: ObservableObject {
    @Published var goals: [Goal] = []
    
    func addGoal(type: String, targetWeight: Double, deadline: Date, notes: String) {
        let newGoal = Goal(
            type: type,
            targetWeight: targetWeight,
            deadline: deadline,
            notes: notes,
            progress: []
        )
        goals.append(newGoal)
    }
}
