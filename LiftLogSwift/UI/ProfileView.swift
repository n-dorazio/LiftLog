//
//  ProfileView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-21.
//

import SwiftUI
import UIKit

// MARK: - User Profile Model

struct Friends: Identifiable {
    let id = UUID()
    let name: String
    let image: String // Name of the image asset
}


struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showSettings = false
    @State private var showAddFriends = false
    @State private var showFriendsList = false
    @StateObject private var userProfile = UserProfileModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                ZStack {
                    Text(userProfile.name)
                        .font(.title2)
                        .bold()
                    HStack {
                        Spacer()
                        Button(action: {
                            showSettings = true
                        }) {
                            Image(systemName: "gearshape")
                                .font(.title2)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Profile Image and Stats
                VStack(spacing: 20) {
                    Image("JaneDoe")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 2)
                        )
                        .shadow(radius: 5)
                    
                    HStack(spacing: 40) {
                        VStack {
                            Text("2")
                                .font(.title2)
                                .bold()
                            Text("Posts")
                                .foregroundColor(.gray)
                        }
                        
                        // Friends Count as Button
                        Button(action: {
                            showFriendsList = true
                        }) {
                            VStack {
                                Text("\(userProfile.friends.count)")
                                    .font(.title2)
                                    .bold()
                                Text("Friends")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Button(action: {
                            showAddFriends = true
                        }) {
                            Image(systemName: "person.badge.plus")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                    }
                    
                    Text(userProfile.bio)
                        .foregroundColor(.gray)
                }
                
                // Top Routines
                VStack(alignment: .leading, spacing: 16) {
                    Text("Top Routines")
                        .font(.title3)
                        .bold()
                    
                    HStack(spacing: 12) {
                        ForEach(userProfile.topRoutines, id: \.self) { routine in
                            Text(routine)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    LinearGradient(colors: [.orange, .red],
                                                 startPoint: .leading,
                                                 endPoint: .trailing)
                                )
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Posts
                VStack(spacing: 16) {
                    SocialPostProfile(
                        username: "Jane Doe",
                        timeAgo: "2s ago",
                        content: "Hey Pookies! Just started using this amazing app called LiftLog. Now my fitness goals seem achievable!!",
                        likes: 121,
                        comments: "34"
                    )
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(userProfile: userProfile)
        }
        .sheet(isPresented: $showAddFriends) {
            AddFriendsView()
        }
        .sheet(isPresented: $showFriendsList) {
            FriendsListView(friends: userProfile.friends)
        }
    }
}

struct FriendsListView: View {
    let friends: [Friends]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List(friends) { friend in
                HStack {
                    Image(friend.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    Text(friend.name)
                        .font(.headline)
                }
            }
            .navigationTitle("Friends")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}

// MARK: - Social Post Profile View

struct SocialPostProfile: View {
    let username: String
    let timeAgo: String
    let content: String
    let comments: String
    let postImage: String?
    let profileImage: String

    @State private var isLiked = false
    @State private var likes: Int

    init(username: String, timeAgo: String, content: String, likes: Int, comments: String, postImage: String? = "JaneDoePost", profileImage: String = "JaneDoe") {
        self.username = username
        self.timeAgo = timeAgo
        self.content = content
        self._likes = State(initialValue: likes)
        self.comments = comments
        self.postImage = postImage
        self.profileImage = profileImage
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with profile image and username
            HStack(spacing: 12) {
                Image(profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 2)
                    )
                    .shadow(radius: 5)

                VStack(alignment: .leading) {
                    Text(username)
                        .font(.headline)
                    Text(timeAgo)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Text(content)
                .padding(.vertical, 4)

            if let postImage = postImage {
                Image(postImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                    .clipped()
                    .overlay(
                        Rectangle().stroke(Color.white, lineWidth: 2)
                    )
            }

            HStack(spacing: 30) {
                // Like Button
                Button(action: {
                    isLiked.toggle()
                    likes += isLiked ? 1 : -1
                }) {
                    HStack {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .gray)
                        Text("\(likes)")
                    }
                }

                // Comments Button
                Button(action: {
                    // Handle comments action
                }) {
                    HStack {
                        Image(systemName: "bubble.right")
                        Text(comments)
                    }
                }

                Spacer()

                // Share Button
                ShareLink(item: content) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                    }
                }
                .foregroundColor(.gray)
            }
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.1), radius: 5)
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Preview

#Preview {
    ProfileView()
}
