//
//  IconsGridView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-12-03.
//

import SwiftUI

struct IconGridView: View {
    @Binding var selectedIcon: String
    let icons = [
        "figure.strengthtraining.traditional",
        "figure.strengthtraining.functional",
        "figure.highintensity.intervaltraining",
        "figure.core.training",
        "figure.climbing",
        "figure.run",
        "figure.walk",
        "figure.boxing",
        "figure.dance",
        "figure.gymnastics",
        "figure.jumprope",
        "figure.mixed.cardio",
        "figure.pilates",
        "figure.pool.swim",
        "figure.rolling",
        "figure.skiing.crosscountry",
        "figure.yoga",
        "dumbbell.fill",
        "bicycle",
        "heart.circle.fill"
    ]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 15) {
            ForEach(icons, id: \.self) { icon in
                IconButton(icon: icon, isSelected: icon == selectedIcon) {
                    selectedIcon = icon
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

struct IconButton: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .frame(width: 60, height: 60)
                .background(isSelected ? Color.gray.opacity(0.2) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .foregroundColor(.black)
        }
    }
}
