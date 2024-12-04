//
//  WorkoutStore.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-12-03.
//

import Foundation

class WorkoutStore: ObservableObject {
    @Published var sessions: [WorkoutSession] = []
    private let userDefaultsKey = "workoutSessions"
    
    init() {
        loadSessions()
    }
    
    private func loadSessions() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([WorkoutSession].self, from: data) {
            sessions = decoded
        }
    }
    
    private func saveSessions() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    func addSession(_ session: WorkoutSession) {
        sessions.append(session)
        saveSessions()
    }
    
    func updateSession(_ session: WorkoutSession) {
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
            saveSessions()
        }
    }
    
    func deleteSession(_ id: UUID) {
        sessions.removeAll { $0.id == id }
        saveSessions()
    }
}
