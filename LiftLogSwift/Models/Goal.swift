//
//  Goal.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import Foundation

struct Goal: Identifiable {
    let id = UUID()
    var type: String
    var name: String
    var targetWeight: Double
    var deadline: Date
    var notes: String
    var progress: [Progress]
    var unit: String
    
    struct Progress: Identifiable {
        let id = UUID()
        var date: Date
        var weight: Double
    }
}
