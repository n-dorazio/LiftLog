//
//  SocialView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-21.
//

import SwiftUI
import PhotosUI
import CoreLocationUI


struct Post: Identifiable {
    let id = UUID() // Unique identifier
    let username: String
    let timeAgo: String
    let content: String
    let profilePicture: String
}


struct SocialView: View {
    let posts = [
         Post(username: "Jordan", timeAgo: "2h ago", content: "Just completed a great workout! 💪", profilePicture: "jordan"),
         Post(username: "Jane Doe", timeAgo: "4h ago", content: "Loving my new fitness routine!", profilePicture: "JaneDoe"),
         Post(username: "Christie", timeAgo: "6h ago", content: "Feeling strong after today's session.", profilePicture: "christie"),
         Post(username: "Yousri", timeAgo: "8h ago", content: "Ran 5k this morning 🏃‍♀️!", profilePicture: "yousri")
     ]
     
     var body: some View {
         NavigationView {
             ScrollView {
                 VStack(spacing: 20) {
                     ForEach(posts) { post in
                         SocialPost(post: post)
                     }
                 }
                 .padding()
             }
             .toolbar {
                 ToolbarItem(placement: .navigationBarTrailing) {
                     NavigationLink(destination: CreatePostView()) {
                         Image(systemName: "plus")
                             .font(.system(size: 20, weight: .bold))
                             .foregroundColor(.white)
                             .frame(width: 40, height: 40)
                             .background(Color.orange)
                             .clipShape(Circle())
                             .shadow(color: .gray.opacity(0.6), radius: 5, x: 0, y: 4)
                     }
                 }
             }
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
    
    let post: Post
    
    @State private var isLiked = false
    @State private var isCommenting = false
    @State private var commentText = ""
    @State private var comments: [Comment] = [] // List of comments
    @State private var showShareSheet = false // State to control share sheet visibility
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
                    // User Info
                    HStack {
                        Image(post.profilePicture)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            Text(post.username)
                                .font(.headline)
                            Text(post.timeAgo)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
            }
            
            // Post Content
            Text(post.content)
            
            // Existing Comments
            if !comments.isEmpty {
                Text("Comments:")
                    .font(.headline)
                
                ForEach(comments) { comment in
                    HStack(alignment: .top) {
                        // Profile Picture
                        Image(comment.profilePicture)
                            .resizable()
                            .frame(width: 40, height: 40)
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
                    .padding(.leading, 20) // Indentation for comments
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
                        .foregroundColor(.gray)
                }
                .sheet(isPresented: $isCommenting) {
                    CommentModalView(
                        commentText: $commentText,
                        onCancel: { isCommenting = false },
                        onPost: { commentText in
                            // Add a new comment with placeholder data
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
                
                Button(action: {
                    showShareSheet = true // Trigger the share sheet
                }) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .font(.headline)
                }
                
                .sheet(isPresented: $showShareSheet) {
                    ShareSheet(items: [
                        "Check out my workout progress! 💪", // Text to share
                        URL(string: "https://example.com/workout")! // Optional URL
                    ])
                    
                }
                .foregroundColor(.gray)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
        }
    }
    
    
    
    // Place this struct at the top level of the file
    struct ShareSheet: UIViewControllerRepresentable {
        var items: [Any] // Items to share
        var activities: [UIActivity]? = nil // Optional custom activities
        
        func makeUIViewController(context: Context) -> UIActivityViewController {
            UIActivityViewController(activityItems: items, applicationActivities: activities)
        }
        
        func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
     
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
    
}










struct CreatePostView: View {
    @State private var postText = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showingImagePicker = false

    var body: some View {
        NavigationView {
            VStack {
                // Main Interactive Box
                VStack {
                    // Text Editor for the Post
                    TextEditor(text: $postText)
                        .frame(height: 150)
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal)

                    // Display selected image (if any)
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }

                    // Modern Image Upload Button
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 18))
                            Text("Add Image")
                                .font(.headline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)

                Spacer()
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .navigationTitle("Create Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Handle post creation
                        print("Post created with text: \(postText), image: \(selectedImage != nil ? "Yes" : "No")")
                    }) {
                        Text("Post")
                            .font(.headline)
                            .foregroundColor(postText.isEmpty ? Color.gray : Color.orange)
                    }
                    .disabled(postText.isEmpty) // Disable button if no text is entered
                }
            }
        }
    }
}



struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }

            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.selectedImage = image as? UIImage
                }
            }
        }
    }
}







#Preview {
    ContentView()
}

