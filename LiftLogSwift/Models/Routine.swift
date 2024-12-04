//
//  Routine.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//
import Foundation

struct Routine: Identifiable, Codable {
    var id: UUID
    var name: String
    var exercises: [Exercise]
    
    init(id: UUID = UUID(), name: String, exercises: [Exercise] = []) {
        self.id = id
        self.name = name
        self.exercises = exercises
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case exercises
    }
}
