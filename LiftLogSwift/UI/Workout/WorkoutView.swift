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
    @State private var searchText = ""
    
    var filteredRoutines: [Routine] {
        if searchText.isEmpty {
            return routineStore.routines
        }
        return routineStore.routines.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search routines...", text: $searchText)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding()
                
                // Routines list
                List {
                    ForEach(filteredRoutines) { routine in
                        RoutineCard(routine: routine)
                            .listRowInsets(EdgeInsets())
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .listRowBackground(Color.clear)
                            .onTapGesture {
                                selectedRoutine = routine
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    routineStore.deleteRoutine(id: routine.id)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Workout Routines")
            .navigationBarItems(
                trailing: Button(action: {
                    showAddRoutine = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.orange, .red]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                }
            )
            .sheet(isPresented: $showAddRoutine) {
                AddRoutineView(routineStore: routineStore)
                    .presentationDetents([.height(300)])
            }
            .sheet(item: $selectedRoutine) { routine in
                RoutineDetailView(routineStore: routineStore, routine: binding(for: routine))
            }
        }
    }

    private func binding(for routine: Routine) -> Binding<Routine> {
        Binding(
            get: { 
                routineStore.routines.first(where: { $0.id == routine.id }) ?? routine
            },
            set: { newValue in
                if let index = routineStore.routines.firstIndex(where: { $0.id == routine.id }) {
                    routineStore.routines[index] = newValue
                    routineStore.objectWillChange.send()
                }
            }
        )
    }
}

struct RoutineCard: View {
    let routine: Routine
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with name and icon
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(routine.name)
                        .font(.title2)
                        .bold()
                    Text("\(routine.exercises.count) exercises")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 24))
                    .foregroundColor(.orange)
                    .padding()
                    .background(
                        Circle()
                            .fill(Color.orange.opacity(0.2))
                    )
            }
            
            // Stats row
            HStack(spacing: 30) {
                // Duration
                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.orange)
                    Text(routine.totalDuration)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Calories
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.orange)
                    Text(routine.totalCalories)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.1), radius: 10)
    }
}

extension String: @retroactive Identifiable {
    public var id: String { self }
}

#Preview {
    WorkoutView()
}




