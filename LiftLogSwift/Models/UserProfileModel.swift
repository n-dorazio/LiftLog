//
//  UserProfileModel.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI

class UserProfileModel: ObservableObject {
    @Published var name: String = "Jane Doe"
    @Published var bio: String = "Fitness enthusiast and cardio lover"
    @Published var topRoutines: [String] = ["Pull-ups", "Sit-ups", "Squats"]
    @Published var profileImage: Image? = nil
    @Published var friends: [Friend] = [
        Friend(id:"John Smith" , name: "John Smith", image: "jordan"),
        Friend(id:"Alice Johnson", name: "Alice Johnson", image: "kate"),
        Friend(id:"Christie", name: "Christie", image: "christie"),
    ]
}
