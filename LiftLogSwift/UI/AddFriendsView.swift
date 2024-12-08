//
//  AddFriendsView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI

struct AddFriendsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var friends: [Friend]
    @State private var searchText = ""
    
    let suggestedFriends = [
        Friend(id: "Yousri", name: "Yousri", image: "yousri"),
        Friend(id: "Kate", name: "Kate", image: "kate"),
        Friend(id: "Jordan", name: "Jordan", image: "jordan"),
        Friend(id: "Christine Gonzales", name: "Christine Gonzales", image: "christie")
    ]
    
    // filter friends based on searchText

    var filteredFriends: [Friend] {
        if searchText.isEmpty {
            return suggestedFriends
        } else {
            return suggestedFriends.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search for People", text: $searchText)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    Button(action: {

                    }) {
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
                        ForEach(filteredFriends) { friend in
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

                                Button(action: {
                                    // Add friend to the user's friends list
                                    if !friends.contains(where: { $0.id == friend.id }) {
                                        friends.append(friend)
                                        // Optionally remove from suggested friends after adding
                                        if let index = suggestedFriends.firstIndex(where: { $0.id == friend.id }) {
                                            suggestedFriends.remove(at: index)
                                        }
                                    }
                                }) {
                                    if friends.contains(where: { $0.id == friend.id }) {
                                        // Friend has been added
                                        HStack {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(.green)
                                            Text("Added")
                                                .font(.subheadline)
                                                .foregroundColor(.green)
                                        }
                                    } else {
                                        // Friend has not been added yet
                                        Image(systemName: "plus.circle")
                                            .font(.title2)
                                            .foregroundColor(.black)
                                    }
                                }
                                .disabled(friends.contains(where: { $0.id == friend.id }))
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

struct Friend: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let image: String
}

struct AddFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendsPreviewWrapper()
    }
}

struct AddFriendsPreviewWrapper: View {
    @State var friends = [Friend]()
    @State var suggestedFriends = [
        Friend(id: "1", name: "John Doe", image: "person"),
        Friend(id: "2", name: "Jane Smith", image: "person.fill"),
        Friend(id: "3", name: "Chris Lee", image: "person.circle")
    ]
    
    var body: some View {
        AddFriendsView(friends: $friends, suggestedFriends: $suggestedFriends)
    }
}
