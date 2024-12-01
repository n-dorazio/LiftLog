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

struct Post: Identifiable {
    let id = UUID()
    let username: String
    let timeAgo: String
    let content: String
    var likes: Int
    var comments: [Comments]
    let postImage: String?
    let profileImage: String
}

struct Comments: Identifiable {
    let id = UUID()
    let username: String
    let content: String
    let profileImage: String
}

let post = Post(
    username: "Jane Doe",
    timeAgo: "2s ago",
    content: "Hey Pookies! Just started using this amazing app called LiftLog. Now my fitness goals seem achievable!!",
    likes: 121,
    comments: [
        Comments(username: "John Smith", content: "Great job!", profileImage: "jordan"),
        Comments(username: "Alice Johnson", content: "Keep it up!", profileImage: "kate"),
        Comments(username: "Bob Lee", content: "Inspirational!", profileImage: "yousri")
    ],
    postImage: "JaneDoePost",
    profileImage: "JaneDoe"
)

struct PostDetailView: View {
    @State var post: Post
    @State private var newCommentText = ""
    @State private var isLiked: Bool = false

    var body: some View {
        VStack(alignment: .leading) { // Set alignment to leading
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
                            isLiked.toggle()
                            post.likes += isLiked ? 1 : -1
                        }) {
                            HStack {
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .foregroundColor(isLiked ? .red : .gray)
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
                .frame(maxWidth: .infinity, alignment: .leading) // Ensure the content takes up full width

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
                            Spacer() // Push content to the left
                        }
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity, alignment: .leading) // Ensure HStack takes up full width
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading) // Ensure VStack takes up full width
            }

            // Comment Input Field
            HStack {
                Image("JaneDoe") // Replace with the current user's profile image
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

    var body: some View {
        NavigationView {
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
                        NavigationLink(destination: PostDetailView(post: post)) {
                            SocialPostProfile(
                                username: post.username,
                                timeAgo: post.timeAgo,
                                content: post.content,
                                likes: post.likes,
                                commentsCount: post.comments.count, // Pass comments count
                                postImage: post.postImage,
                                profileImage: post.profileImage
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                        .buttonStyle(PlainButtonStyle()) // Remove the default NavigationLink styling
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
    let username: String
    let timeAgo: String
    let content: String
    let likes: Int
    let commentsCount: Int
    let postImage: String?
    let profileImage: String

    @State private var isLiked = false

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
                    // Handle like action if needed
                }) {
                    HStack {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .gray)
                        Text("\(likes)")
                    }
                }

                // Comment Button
                Button(action: {
                    // Handle comment button action if needed
                }) {
                    HStack {
                        Image(systemName: "bubble.right")
                        Text("\(commentsCount)")
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
