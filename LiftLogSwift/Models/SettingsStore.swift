//
//  SettingsStore.swift
//  LiftLogSwift
//
//  Created by Hassan Baig on 2024-12-05.
//

import SwiftUI
import Foundation

class SettingsStore: ObservableObject {
    // Toggle states
    @Published var isProfilePublic: Bool = false {
        didSet { saveSettings() }
    }
    @Published var autoShareWorkouts: Bool = false {
        didSet { saveSettings() }
    }
    @Published var notifications: Bool = true {
        didSet { saveSettings() }
    }
    @Published var restDayReminders: Bool = false {
        didSet { saveSettings() }
    }
    @Published var waterIntakeReminders: Bool = false {
        didSet { saveSettings() }
    }
    @Published var workoutReminders: Bool = true {
        didSet { saveSettings() }
    }
    
    // Additional settings
    @Published var weight: String = "140" {
        didSet { saveSettings() }
    }
    @Published var gender: String = "Female" {
        didSet { saveSettings() }
    }
    @Published var birthday: String = "11/03/2003" {
        didSet { saveSettings() }
    }
    @Published var username: String = "JaneDoe123" {
        didSet { saveSettings() }
    }
    @Published var password: String = "•••••••••" {
        didSet { saveSettings() }
    }
    
    init() {
        loadSettings()
    }
    
    // File path
    private var settingsFileURL: URL {
        getDocumentsDirectory().appendingPathComponent("settings.json")
    }
    
    // Saving function
    func saveSettings() {
        let settings = Settings(
            isProfilePublic: isProfilePublic,
            autoShareWorkouts: autoShareWorkouts,
            notifications: notifications,
            restDayReminders: restDayReminders,
            waterIntakeReminders: waterIntakeReminders,
            workoutReminders: workoutReminders,
            weight: weight,
            gender: gender,
            birthday: birthday,
            username: username,
            password: password
        )
        
        do {
            let data = try JSONEncoder().encode(settings)
            try data.write(to: settingsFileURL)
        } catch {
            print("Error saving settings: \(error)")
        }
    }
    
    // Loading function
    func loadSettings() {
        do {
            let data = try Data(contentsOf: settingsFileURL)
            let settings = try JSONDecoder().decode(Settings.self, from: data)
            DispatchQueue.main.async {
                self.isProfilePublic = settings.isProfilePublic
                self.autoShareWorkouts = settings.autoShareWorkouts
                self.notifications = settings.notifications
                self.restDayReminders = settings.restDayReminders
                self.waterIntakeReminders = settings.waterIntakeReminders
                self.workoutReminders = settings.workoutReminders
                self.weight = settings.weight
                self.gender = settings.gender
                self.birthday = settings.birthday
                self.username = settings.username
                self.password = settings.password
            }
        } catch {
            print("Error loading settings: \(error)")
            // Use default settings if needed
        }
    }
    
    // Helper function to get documents directory
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

// Struct to hold settings data
struct Settings: Codable {
    var isProfilePublic: Bool
    var autoShareWorkouts: Bool
    var notifications: Bool
    var restDayReminders: Bool
    var waterIntakeReminders: Bool
    var workoutReminders: Bool
    var weight: String
    var gender: String
    var birthday: String
    var username: String
    var password: String
}
