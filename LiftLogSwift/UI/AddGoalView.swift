//
//  AddGoalView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI

struct AddGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var goalStore: GoalStore
    @State private var goalType = "Weight Loss"
    @State private var targetWeight = ""
    @State private var deadline = Date()
    @State private var notes = ""
    
    let goalTypes = ["Weight Loss", "Muscle Gain", "Strength", "Endurance"]
    
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
                
                // Target Weight Section
                Section(header: Text("Target Weight")) {
                    HStack {
                        TextField("200", text: $targetWeight)
                            .keyboardType(.decimalPad)
                        Text("Lbs")
                            .foregroundColor(.gray)
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
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func saveGoal() {
        if let weight = Double(targetWeight) {
            goalStore.addGoal(
                type: goalType,
                targetWeight: weight,
                deadline: deadline,
                notes: notes
            )
        }
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddGoalView(goalStore: GoalStore())
}


