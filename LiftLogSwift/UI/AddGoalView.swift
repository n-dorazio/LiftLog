//
//  AddGoalView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI

struct AddGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    //@ObservedObject var goalStore: GoalStore
    @State private var goalType = "Weight Loss"
    @State private var customGoalType = ""
    @State private var goalUnit = "Lbs"
    @State private var customGoalUnit = "..."
    @State private var targetWeight = ""
    @State private var deadline = Date()
    @State private var notes = ""
    @State private var isEmpty = true
    @State private var isFull = false
    @Binding public var goals: [Goal]
    
    let goalTypes = ["Weight Loss", "Muscle Gain", "Strength", "Endurance", "Custom"]
    let goalUnits = ["Lbs", "kgs", "in.", "cm", "km", "cal.", "steps", "minutes", "hours", "custom"]
    
    var body: some View {
        NavigationView {
            Form {
                // Goal Type Section
                Section(header: Text("Goal Type")) {
                    Picker("Goal Type", selection: $goalType) {
                        ForEach(goalTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                }
                
                if goalType == "Custom" {
                    // Target Weight Section
                    Section(header: Text("Custom Goal Type")) {
                        HStack {
                            TextField("Enter name here", text: $customGoalType)
                                .keyboardType(.decimalPad)
                        }
                    }
                }
            
                // Target Metric Section
                Section(header: Text("Goal Target")) {
                    Picker("Units", selection: $goalUnit) {
                        ForEach(goalUnits, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    if goalUnit == "custom" {
                        HStack {
                            TextField("Enter desired units", text: $customGoalUnit)
                                .keyboardType(.decimalPad)
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
                Section(header: Text("Deadline")) {
                    DatePicker("", selection: $deadline, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                }
                
                // Notes Section
                Section(header: Text("Notes")) {
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
                    .listRowBackground(Color.orange)
                }
            }
            .navigationTitle("Set New Goal")
            .navigationBarItems(
                leading: Button("Cancel") {
                    newGoalIsEmpty(goalType: goalType, customGoalType: customGoalType, goalUnit: goalUnit, customGoalUnit: customGoalUnit, targetWeight: targetWeight, deadline: deadline, notes: notes, isEmpty: isEmpty)
                    if !isEmpty {
                        //print("is not empty again")
                        print("TODO: INSERT A CONFIRMATION SCREEN THAT ALL UNSAVED INFO WILL BE LOST")
                        // TODO: INSERT A CONFIRMATION SCREEN THAT ALL UNSAVED INFO WILL BE LOST
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func saveGoal() {
        newGoalIsFilled(goalType: goalType, customGoalType: customGoalType, goalUnit: goalUnit, customGoalUnit: customGoalUnit, targetWeight: targetWeight, deadline: deadline, notes: notes, isFull: isFull)
        
        if isFull {
            let gs = GoalStore(internalGoals: &goals)
            gs.addGoal(
                type: goalType,
                targetWeight: Double(targetWeight) ?? 0,
                deadline: deadline,
                notes: notes
            )
            gs.syncWithExternalArray(to: &goals)
            presentationMode.wrappedValue.dismiss()
        }
        else {
            print("TODO: add error screen that goal is still missing details")
            // TODO: add error screen that goal is still missing details
        }
        
    }
    
    private func newGoalIsEmpty(goalType: String, customGoalType: String, goalUnit: String, customGoalUnit: String, targetWeight: String, deadline: Date, notes: String, isEmpty: Bool) {
        if goalType == "Custom" {
            if customGoalType != "" {
                self.isEmpty = false
                //print("is not empty")
            }
        }
        else if goalUnit == "custom" {
            if customGoalUnit != "..." {
                self.isEmpty = false
                //print("unit not empty")
            }
        }
        else if targetWeight != "" {
            self.isEmpty = false
            //print("target is not empty")
        }
        else if notes != "" {
            self.isEmpty = false
            //print("notes is not empty")
        }
        else {
            self.isEmpty = true
        }
        
    }
    
    private func newGoalIsFilled(goalType: String, customGoalType: String, goalUnit: String, customGoalUnit: String, targetWeight: String, deadline: Date, notes: String, isFull: Bool) {
        if ((goalType == "Custom" && customGoalType == "") || (goalUnit == "custom" && customGoalUnit == "...") || targetWeight == "") {
            self.isFull = false
            //print("not full")
        }
        else {
            self.isFull = true
            //print("full")
        }
    }
}

#Preview {
    @Previewable @State var goals: [Goal] = []
    AddGoalView(goals: $goals)
}


