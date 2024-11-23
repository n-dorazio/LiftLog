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

// Define the Comment struct
struct Comment: Identifiable {
    let id = UUID() // Unique identifier for each comment
    let username: String
    let profilePicture: String // Use image name from the asset catalog
    let text: String
}

struct SocialPost: View {
    @State private var isLiked = false
    @State private var isCommenting = false
    @State private var commentText = ""
    @State private var comments: [Comment] = [] // List of comments

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

            // Existing Comments
            if !comments.isEmpty {
                Text("Comments:")
                    .font(.headline)
                ForEach(comments) { comment in
                    HStack(alignment: .top) {
                        // Profile Picture
                        Image(comment.profilePicture)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))

                        VStack(alignment: .leading) {
                            // Username
                            Text(comment.username)
                                .font(.subheadline)
                                .fontWeight(.bold)
                            // Comment Text
                            Text(comment.text)
                                .font(.body)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 4)
                    
                    
                }
            }

            // Interaction Buttons
            HStack {
                Button(action: {
                    isLiked.toggle()
                }) {
                    Label("Like", systemImage: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : .gray)
                }
                Spacer()
                Button(action: {
                    isCommenting = true // Show the comment modal
                }) {
                    Label("Comment", systemImage: "message")
                }
                .sheet(isPresented: $isCommenting) {
                    CommentModalView(
                        commentText: $commentText,
                        onCancel: { isCommenting = false },
                        onPost: { commentText in
                            // Add a new comment with a placeholder username and profile picture
                            let newComment = Comment(
                                username: "Current User",
                                profilePicture: "profile_placeholder", // Replace with actual image name
                                text: commentText
                            )
                            comments.append(newComment)
                            isCommenting = false // Dismiss the modal
                        }
                    )
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



struct CommentModalView: View {
    @Binding var commentText: String // Binding to share the comment text
    var onCancel: () -> Void // Closure for dismissing the modal
    var onPost: (String) -> Void // Closure for posting the comment

    @FocusState private var isFocused: Bool // Focus state for TextField

    var body: some View {
        NavigationView {
            VStack {
                TextField("Write a comment...", text: $commentText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.sentences)
                    .keyboardType(.default)
                    .focused($isFocused) // Attach focus state to TextField

                Spacer()
            }
            .navigationTitle("Add Comment")
            .navigationBarItems(
                leading: Button("Cancel") {
                    onCancel() // Dismiss the modal
                },
                trailing: Button("Post") {
                    onPost(commentText) // Pass comment to the onPost closure
                    onCancel() // Dismiss the modal after posting
                }
            )
            .onAppear {
                isFocused = true // Automatically focus the TextField when the modal opens
            }
        }
    }
}




#Preview {
    ContentView()
}
