//
//  AddGoalView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI

struct AddGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var goalType = "Weight Loss"
    @State private var goalUnit = "Lbs"
    @State private var customGoalUnit = "..."
    @State private var targetWeight = ""
    @State private var deadline = Date()
    @State private var notes = ""
    @State private var isEmpty = true
    @State private var isFull = false
    @Binding public var goals: [Goal]
    @State private var goalName = ""
    
    let goalTypes = ["Weight Loss", "Muscle Gain", "Strength", "Endurance", "Custom"]
    let goalUnits = ["Lbs", "kgs", "in.", "cm", "km", "cal.", "steps", "minutes", "hours", "custom"]
    
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
                    if goalUnit != "custom" {
                        HStack {
                            TextField("200", text: $targetWeight)
                                .keyboardType(.decimalPad)
                            Text("\(goalUnit)")
                                .foregroundColor(.gray)
                        }
                    }
                    else {
                        HStack {
                            TextField("200", text: $targetWeight)
                                .keyboardType(.decimalPad)
                            Text("\(customGoalUnit)")
                                .foregroundColor(.gray)
                        }
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
                            Text("Save")
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
            .navigationTitle("Set New Goal")
            .navigationBarItems(
                leading: Button("Cancel") {
                    newGoalIsEmpty(goalType: goalType, goalUnit: goalUnit, customGoalUnit: customGoalUnit, targetWeight: targetWeight, deadline: deadline, notes: notes, isEmpty: isEmpty)
                    if !isEmpty {
                        print("TODO: INSERT A CONFIRMATION SCREEN THAT ALL UNSAVED INFO WILL BE LOST")
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func saveGoal() {
        newGoalIsFilled(goalType: goalType, goalName: goalName, goalUnit: goalUnit, customGoalUnit: customGoalUnit, targetWeight: targetWeight, deadline: deadline, notes: notes, isFull: isFull)
        
        if isFull {
            let gs = GoalStore(internalGoals: &goals)
            gs.addGoal(
                type: goalType,
                name: goalName,
                targetWeight: Double(targetWeight) ?? 0,
                deadline: deadline,
                notes: notes,
                unit: goalUnit == "custom" ? customGoalUnit : goalUnit
            )
            gs.syncWithExternalArray(to: &goals)
            presentationMode.wrappedValue.dismiss()
        }
        else {
            print("TODO: add error screen that goal is still missing details")
        }
    }
    
    private func newGoalIsFilled(goalType: String, goalName: String, goalUnit: String, customGoalUnit: String, targetWeight: String, deadline: Date, notes: String, isFull: Bool) {
        if goalType == "Custom" && goalName.isEmpty {
            self.isFull = false
            return
        }
        
        if goalUnit == "custom" && customGoalUnit == "..." {
            self.isFull = false
            return
        }
        
        if targetWeight.isEmpty {
            self.isFull = false
            return
        }
        
        self.isFull = true
    }
    
    private func newGoalIsEmpty(goalType: String, goalUnit: String, customGoalUnit: String, targetWeight: String, deadline: Date, notes: String, isEmpty: Bool) {
        if goalType == "Custom" {
            if goalName != "" {
                self.isEmpty = false
            }
        }
        else if goalUnit == "custom" {
            if customGoalUnit != "..." {
                self.isEmpty = false
            }
        }
        else if targetWeight != "" {
            self.isEmpty = false
        }
        else if notes != "" {
            self.isEmpty = false
        }
        else {
            self.isEmpty = true
        }
    }
}

#Preview {
    @Previewable @State var goals: [Goal] = []
    return AddGoalView(goals: $goals)
}


