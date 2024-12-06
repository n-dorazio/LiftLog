//
//  GoalStore.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import Foundation
import SwiftUI

class GoalStore: ObservableObject {
    private var internalGoals: [Goal]
    
    func addGoal(type: String, name: String, targetWeight: Double, deadline: Date, notes: String, unit: String) {
        let newGoal = Goal(
            type: type,
            name: name,
            targetWeight: targetWeight,
            deadline: deadline,
            notes: notes,
            progress: [],
            unit: unit
        )
        internalGoals.append(newGoal)
    }
    
    init (internalGoals: inout [Goal]) {
        self.internalGoals = internalGoals
    }
    
    func syncWithExternalArray(to array: inout [Goal]) {
        array = internalGoals
    }
}
