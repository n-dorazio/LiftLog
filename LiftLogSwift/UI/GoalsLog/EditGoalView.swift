//
//  EditGoalView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-12-06.
//

import SwiftUI

struct EditGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    let goal: Goal
    @Binding var goals: [Goal]
    
    @State private var goalType: String
    @State private var goalName: String
    @State private var goalUnit: String
    @State private var customGoalUnit: String
    @State private var targetWeight: String
    @State private var deadline: Date
    @State private var notes: String
    @State private var isEmpty = true
    @State private var isFull = false
    
    let goalTypes = ["Weight Loss", "Muscle Gain", "Strength", "Endurance", "Custom"]
    let goalUnits = ["Lbs", "kgs", "in.", "cm", "km", "cal.", "steps", "minutes", "hours", "custom"]
    
    init(goal: Goal, goals: Binding<[Goal]>) {
        self.goal = goal
        self._goals = goals
        _goalType = State(initialValue: goal.type)
        _goalName = State(initialValue: goal.name)
        _goalUnit = State(initialValue: goal.unit == "..." ? "custom" : goal.unit)
        _customGoalUnit = State(initialValue: goal.unit)
        _targetWeight = State(initialValue: String(format: "%.1f", goal.targetWeight))
        _deadline = State(initialValue: goal.deadline)
        _notes = State(initialValue: goal.notes)
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Goal Type Section
                Section(header: Text("Goal Type").foregroundColor(.orange)) {
                    Picker("Goal Type", selection: $goalType) {
                        ForEach(goalTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    
                    TextField("Goal Name", text: $goalName)
                        .textInputAutocapitalization(.words)
                }
                
                // Target Metric Section
                Section(header: Text("Goal Target").foregroundColor(.orange)) {
                    Picker("Units", selection: $goalUnit) {
                        ForEach(goalUnits, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    if goalUnit == "custom" {
                        HStack {
                            TextField("Enter desired units", text: $customGoalUnit)
                            Text("Custom units")
                                .foregroundColor(.gray)
                        }
                    }
                    HStack {
                        TextField("200", text: $targetWeight)
                            .keyboardType(.decimalPad)
                        Text(goalUnit == "custom" ? customGoalUnit : goalUnit)
                            .foregroundColor(.gray)
                    }
                }
                
                // Deadline Section
                Section(header: Text("Deadline").foregroundColor(.orange)) {
                    DatePicker("", selection: $deadline, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                }
                
                // Notes Section
                Section(header: Text("Notes").foregroundColor(.orange)) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
                
                // Save Button
                Section {
                    Button(action: saveGoal) {
                        HStack {
                            Text("Save Changes")
                            Image(systemName: "square.and.arrow.down")
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                    }
                    .listRowBackground(
                        LinearGradient(
                            gradient: Gradient(colors: [.orange, .red]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                }
            }
            .navigationTitle("Edit Goal")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func saveGoal() {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            let updatedGoal = Goal(
                type: goalType,
                name: goalName,
                targetWeight: Double(targetWeight) ?? 0,
                deadline: deadline,
                notes: notes,
                progress: goal.progress,
                unit: goalUnit == "custom" ? customGoalUnit : goalUnit
            )
            goals[index] = updatedGoal
            presentationMode.wrappedValue.dismiss()
        }
    }
}
