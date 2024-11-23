//
//  WorkoutView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-21.
//


import SwiftUI

struct WorkoutView: View {
    @StateObject private var routineStore = RoutineStore()
    @State private var showAddRoutine = false
    @State private var selectedRoutine: Routine?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(routineStore.routines) { routine in
                        Button(action: {
                            selectedRoutine = routine
                        }) {
                            HStack {
                                Text(routine.name)
                                    .font(.title3)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gray.opacity(0.1))
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Workout Routines")
            .navigationBarItems(
                trailing: Button(action: {
                    showAddRoutine = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            )
            .sheet(isPresented: $showAddRoutine) {
                AddRoutineView(routineStore: routineStore)
                    .presentationDetents([.height(250)])
            }
            .sheet(item: $selectedRoutine) { routine in
                RoutineDetailView(routineStore: routineStore, routine: routine)
            }
        }
    }
}

extension String: Identifiable {
    public var id: String { self }
}

#Preview {
    WorkoutView()
}


