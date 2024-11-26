//
//  SocialView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-21.
//

import SwiftUI

struct SocialView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(0..<5) { _ in
                        SocialPost()
                    }
                }
                .padding()
            }
            .navigationTitle("Social")
        }
    }
}

struct SocialPost: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // User Info
            HStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                VStack(alignment: .leading) {
                    Text("User Name")
                        .font(.headline)
                    Text("2h ago")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            // Post Content
            Text("Just completed a great workout! 💪")
            
            // Interaction Buttons
            HStack {
                Button(action: {}) {
                    Label("Like", systemImage: "heart")
                }
                Spacer()
                Button(action: {}) {
                    Label("Comment", systemImage: "message")
                }
                Spacer()
                Button(action: {}) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }
}

#Preview {
    SocialView()
}
