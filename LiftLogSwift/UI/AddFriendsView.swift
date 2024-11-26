//
//  AddFriendsView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI

struct AddFriendsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    
    let suggestedFriends = [
        Friend(name: "Yousri", image: "yousri"),
        Friend(name: "Kate", image: "kate"),
        Friend(name: "Jordan", image: "jordan"),
        Friend(name: "Christine Gonzales", image: "christie")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search for People", text: $searchText)
                    Button(action: {}) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(25)
                .padding(.horizontal)
                
                // Suggested Friends List
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(suggestedFriends) { friend in
                            HStack {
                                Image(friend.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(Color.white, lineWidth: 2)
                                    )

                                Text(friend.name)
                                    .font(.title3)
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Image(systemName: "plus.circle")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(color: .gray.opacity(0.1), radius: 5)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
            )
            .navigationTitle("Add Friends")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct Friend: Identifiable {
    let id = UUID()
    let name: String
    let image: String
}

#Preview {
    AddFriendsView()
}
