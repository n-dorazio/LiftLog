//
//  ProfileView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-21.
//

import SwiftUI
import UIKit
import Foundation


struct ExistingPosts: Identifiable, Codable {
    let id: UUID
    let username: String
    let timeAgo: String
    let content: String
    var likes: Int
    var isLiked: Bool
    var comments: [Comments]
    let postImage: String?
    let profileImage: String

    
    init(id: UUID = UUID(), username: String, timeAgo: String, content: String, likes: Int, isLiked: Bool = false, comments: [Comments], postImage: String?, profileImage: String) {
        self.id = id
        self.username = username
        self.timeAgo = timeAgo
        self.content = content
        self.likes = likes
        self.isLiked = isLiked
        self.comments = comments
        self.postImage = postImage
        self.profileImage = profileImage
    }
}

struct Comments: Identifiable, Codable {
    let id: UUID
    let username: String
    let content: String
    let profileImage: String

    // initialize properties
    init(id: UUID = UUID(), username: String, content: String, profileImage: String) {
        self.id = id
        self.username = username
        self.content = content
        self.profileImage = profileImage
    }
}

struct PostDetailView: View {
    @Binding var post: ExistingPosts
    @State private var newCommentText = ""

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                // Post Content
                VStack(alignment: .leading, spacing: 12) {
                    // Header with profile image and username
                    HStack(spacing: 12) {
                        Image(post.profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2)
                            )
                            .shadow(radius: 5)

                        VStack(alignment: .leading) {
                            Text(post.username)
                                .font(.headline)
                            Text(post.timeAgo)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }

                    Text(post.content)
                        .padding(.vertical, 4)

                    if let postImage = post.postImage {
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
                            post.isLiked.toggle()
                            post.likes += post.isLiked ? 1 : -1
                        }) {
                            HStack {
                                Image(systemName: post.isLiked ? "heart.fill" : "heart")
                                    .foregroundColor(post.isLiked ? .red : .gray)
                                Text("\(post.likes)")
                            }
                        }

                        // Comments Count
                        HStack {
                            Image(systemName: "bubble.right")
                            Text("\(post.comments.count)")
                        }

                        Spacer()

                        // Share Button
                        ShareLink(item: post.content) {
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
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)

                // Comments Section
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(post.comments) { comment in
                        HStack(alignment: .top, spacing: 12) {
                            Image(comment.profileImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())

                            VStack(alignment: .leading) {
                                Text(comment.username)
                                    .font(.headline)
                                Text(comment.content)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // comment input field
            HStack {
                Image("JaneDoe")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())

                TextField("Add a comment...", text: $newCommentText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    if !newCommentText.trimmingCharacters(in: .whitespaces).isEmpty {
                        let newComment = Comments(username: "Jane Doe", content: newCommentText, profileImage: "JaneDoe")
                        post.comments.append(newComment)
                        newCommentText = ""
                    }
                }) {
                    Text("Post")
                        .bold()
                }
                .disabled(newCommentText.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding()
            .background(Color.white)
        }
        .navigationBarTitle("Post", displayMode: .inline)
    }
}


struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showSettings = false
    @State private var showAddFriends = false
    @State private var showFriendsList = false
    @StateObject private var userProfile = UserProfileModel()
    @StateObject private var settingsStore = SettingsStore()

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
                    // Load custom image if available
                    if let imageURL = userProfile.imageURL(),
                       let imageData = try? Data(contentsOf: imageURL),
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 5)
                    } else {
                        // Fallback to default image
                        Image("JaneDoe")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 5)
                    }

                    HStack(spacing: 40) {
                        VStack {
                            Text("\(userProfile.posts.count)")
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
                                    .foregroundColor(.black)
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
                    ForEach($userProfile.posts) { $post in
                        NavigationLink(destination: PostDetailView(post: $post)) {
                            SocialPostProfile(post: $post)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(userProfile: userProfile, settings: settingsStore)
        }
        .sheet(isPresented: $showAddFriends) {
            AddFriendsView(friends: $userProfile.friends)
        }
        .sheet(isPresented: $showFriendsList) {
            FriendsListView(friends: userProfile.friends)
        }
    }
}

struct FriendsListView: View {
    let friends: [Friend]
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

struct CommentSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var comments: [String]
    @State private var newCommentText = ""

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(comments, id: \.self) { comment in
                        Text(comment)
                    }
                }

                Divider()

                HStack {
                    TextField("Add a comment...", text: $newCommentText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        if !newCommentText.trimmingCharacters(in: .whitespaces).isEmpty {
                            comments.append(newCommentText)
                            newCommentText = ""
                        }
                    }) {
                        Text("Post")
                            .bold()
                    }
                    .disabled(newCommentText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()
            }
            .navigationTitle("Comments")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}

struct SocialPostProfile: View {
    @Binding var post: ExistingPosts

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with profile image and username
            HStack(spacing: 12) {
                Image(post.profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 2)
                    )
                    .shadow(radius: 5)

                VStack(alignment: .leading) {
                    Text(post.username)
                        .font(.headline)
                    Text(post.timeAgo)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Text(post.content)
                .padding(.vertical, 4)

            if let postImage = post.postImage {
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
                    post.isLiked.toggle()
                    post.likes += post.isLiked ? 1 : -1
                }) {
                    HStack {
                        Image(systemName: post.isLiked ? "heart.fill" : "heart")
                            .foregroundColor(post.isLiked ? .red : .gray)
                        Text("\(post.likes)")
                    }
                }

                // Comment Button
                HStack {
                    Image(systemName: "bubble.right")
                    Text("\(post.comments.count)")
                }

                Spacer()

                // Share Button
                ShareLink(item: post.content) {
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

#Preview {
    ProfileView()
}
