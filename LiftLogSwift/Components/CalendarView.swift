//
//  CalendarView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-12-07.
//

import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    var onClose: (() -> Void)?
    @State private var internalDate: Date
    
    init(selectedDate: Binding<Date>, onClose: (() -> Void)? = nil) {
        self._selectedDate = selectedDate
        self.onClose = onClose
        self._internalDate = State(initialValue: selectedDate.wrappedValue)
    }
    
    var body: some View {
        VStack {
            // Header with close button
            HStack {
                Text("Select a Date")
                    .font(.system(size: 25, weight: .bold))
                    .padding()
                
                Spacer()
                
                Button(action: {
                    onClose?()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            
            DatePicker(
                "Date",
                selection: $internalDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
            
            Button(action: {
                selectedDate = internalDate
                onClose?()
            }) {
                Text("Done")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Capsule().fill(Color.orange))
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .padding()
        .frame(height: 500)
        .background(Color.white)
        .cornerRadius(20)
    }
}
