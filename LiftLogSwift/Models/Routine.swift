//
//  Routine.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//
import Foundation

struct Routine: Identifiable {
    let id = UUID()
    let name: String
    var exercises: [Exercise] = []
}
