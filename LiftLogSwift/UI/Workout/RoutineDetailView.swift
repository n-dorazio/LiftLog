//
//  RoutineDetailView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI

struct RoutineDetailView: View {
    @ObservedObject var routineStore: RoutineStore
    @Binding var routine: Routine
    @Environment(\.presentationMode) var presentationMode
    @State private var showAddExercise = false
    @State private var selectedExerciseIndex: Int?
    @State private var showEditExercise = false
    @State private var selectedExercise: Exercise?
    @State private var showWorkoutSession = false
    
    var body: some View {
        NavigationView {
            ExerciseListContent(
                routine: $routine,
                routineStore: routineStore,
                selectedExerciseIndex: $selectedExerciseIndex,
                selectedExercise: $selectedExercise,
                showEditExercise: $showEditExercise,
                showWorkoutSession: $showWorkoutSession
            )
            .navigationTitle(routine.name)
            .navigationBarItems(
                leading: backButton,
                trailing: addButton
            )
            .sheet(isPresented: $showAddExercise) {
                AddExerciseView(routineStore: routineStore, routine: $routine)
            }
            .sheet(isPresented: $showEditExercise) {
                if let exercise = selectedExercise {
                    AddExerciseView(routineStore: routineStore, routine: $routine, exercise: exercise)
                }
            }
            .sheet(isPresented: $showWorkoutSession) {
                if let index = selectedExerciseIndex {
                    WorkoutSessionView(
                        workoutStore: WorkoutStore(),
                        routine: routine,
                        initialExerciseIndex: index
                    )
                }
            }
        }
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .font(.title2)
                .foregroundColor(.black)
        }
    }
    
    private var addButton: some View {
        Button(action: {
            showAddExercise = true
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
    }
}

struct ExerciseListContent: View {
    @Binding var routine: Routine
    let routineStore: RoutineStore
    @Binding var selectedExerciseIndex: Int?
    @Binding var selectedExercise: Exercise?
    @Binding var showEditExercise: Bool
    @Binding var showWorkoutSession: Bool
    
    var body: some View {
        List {
            ForEach(Array(routine.exercises.enumerated()), id: \.element.id) { index, exercise in
                RoutineExerciseCard(
                    exercise: exercise,
                    onStart: {
                        selectedExerciseIndex = index
                        showWorkoutSession = true
                    },
                    onEdit: {
                        selectedExercise = exercise
                        showEditExercise = true
                    }
                )
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .padding(.vertical, 8)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        routineStore.deleteExercise(routineId: routine.id, exerciseId: exercise.id)
                        routine.exercises.removeAll { $0.id == exercise.id }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct RoutineExerciseCard: View {
    let exercise: Exercise
    let onStart: () -> Void
    let onEdit: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            // Header with exercise name
            HStack {
                Text(exercise.name)
                    .font(.system(size: 24, weight: .bold))
                Spacer()
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .foregroundColor(.gray)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Icon with stats
            HStack(spacing: 30) {
                Image(systemName: exercise.icon)
                    .font(.system(size: 50))
                    .foregroundColor(.orange)
                    .padding()
                    .background(
                        Circle()
                            .fill(Color.orange.opacity(0.2))
                            .frame(width: 100, height: 100)
                    )
                
                Spacer()
                
                // Stats
                VStack(alignment: .trailing, spacing: 12) {
                    HStack {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.orange)
                        Text(exercise.duration)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.orange)
                        Text(exercise.calories)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            // Start Button
            Button(action: onStart) {
                HStack {
                    Text("Start Exercise")
                        .font(.title3)
                        .bold()
                    Image(systemName: "arrow.right")
                        .font(.title3)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.orange, .red]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(20)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.1), radius: 10)
    }
}

// Helper struct to make the index Identifiable
struct IndexWrapper: Identifiable {
    let id = UUID()
    let index: Int
}



