//
//  Exercise.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import Foundation

struct Exercise: Identifiable {
    let id: UUID
    let name: String
    let notes: String
    let duration: String
    let calories: String
    let icon: String
    
    init(name: String, notes: String = "", duration: String = "15 Mins", calories: String = "100Kcals", icon: String = "figure.strengthtraining.traditional") {
        self.id = UUID()
        self.name = name
        self.notes = notes
        self.duration = duration
        self.calories = calories
        self.icon = icon
    }
}
