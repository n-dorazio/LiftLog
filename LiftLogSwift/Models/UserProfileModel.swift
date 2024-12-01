//
//  UserProfileModel.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI

class UserProfileModel: ObservableObject {
    @Published var name: String = "Jane Doe"
    @Published var bio: String = "I love cardio"
    @Published var topRoutines: [String] = ["Chest Workout", "Cardio Warm-Up", "Leg Workout"]
    @Published var profileImage: Image? = nil
    @Published var friends: [Friends] = [
        Friends(name: "John Smith", image: "jordan"),
        Friends(name: "Alice Johnson", image: "kate"),
        ]
}
