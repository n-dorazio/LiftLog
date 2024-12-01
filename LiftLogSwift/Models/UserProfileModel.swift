//
//  UserProfileModel.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI


class UserProfileModel: ObservableObject {
    @Published var name: String = "Jane Doe"
    @Published var bio: String = "Fitness enthusiast"
    @Published var topRoutines: [String] = ["Leg Press", "Squats", "Pull-Ups"]
//    @Published var friends: [Friends] = [
//        Friends(name: "John Smith", image: "jordan"),
//        Friends(name: "Alice Johnson", image: "kate"),
//        Friends(name: "Christie", image: "christie"),
//    ]
}
