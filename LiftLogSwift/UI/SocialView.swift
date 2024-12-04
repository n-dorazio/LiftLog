//
//  SocialView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-21.
//
import SwiftUI
import PhotosUI
import CoreLocationUI


class PostsManager: ObservableObject {
    @Published var posts: [Post] = [
        Post(username: "Jordan", timeAge: "2h ago", profilePicture: "jordan", content: "Just completed a great workout! 💪"),
        Post(username: "Jane Doe", timeAge: "4h ago", profilePicture: "JaneDoe", content: "Loving my new fitness routine!"),
        Post(username: "Christie", timeAge: "6h ago", profilePicture: "christie", content: "Feeling strong after today's session."),
        Post(username: "Yousri", timeAge: "8h ago", profilePicture: "yousri", content: "Ran 5k this morning 🏃‍♀️!")
    ]
}

struct Post: Identifiable {
    let id = UUID() // Unique identifier for each post
    let username: String
    let timeAge: String
    let profilePicture: String
    
    let content: String
}

struct SocialView: View {
   
    @StateObject var postsManager = PostsManager()

  
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    // Use ForEach to dynamically create posts
                    ForEach(postsManager.posts) { post in
                        SocialPost(post: post) // Pass each post to SocialPost

                    }
                }
                .padding()
            }
            .navigationTitle("Social Feed")
            .toolbar {
                // Add Post (+) and Messages Buttons
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 15) {
                        // Add Post Button
                        NavigationLink(destination: CreatePostView(postsManager: postsManager)) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.orange)
                                .clipShape(Circle())
                                //.shadow(color: .gray.opacity(0.6), radius: 5, x: 0, y: 4)
                        }
                        // Messages Button
                        NavigationLink(destination: MessagingView()) {
                            Image(systemName: "message")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.orange)
                                .clipShape(Circle())
                                //.shadow(color: .gray.opacity(0.6), radius: 5, x: 0, y: 4)
                        }
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
    let post: Post // Receive the Post object for dynamic data

        @State private var isLiked = false
        @State private var isCommenting = false
        @State private var commentText = ""
        @State private var comments: [Comment] = [] // Dynamic list of comments
        @State private var showShareSheet = false

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                // User Info
                HStack {
                    Image(post.profilePicture) // Display the actual profile picture
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text(post.username) // Display the username
                            .font(.headline)
                        Text(post.timeAge) // Display the time ago
                            .font(.caption)
                            .foregroundColor(.gray)

                    }
                    Spacer()
                }

                // Post Content
                Text(post.content) // Display the actual post content

                // Comments Section
                if !comments.isEmpty {
                    Text("Comments:")
                        .font(.headline)

                    ForEach(comments) { comment in
                        HStack(alignment: .top) {
                            Image(comment.profilePicture) // Commenter's profile picture
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            
                            VStack(alignment: .leading) {
                                Text(comment.username) // Commenter's username
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                Text(comment.text) // Comment text
                                    .font(.body)
                            }
                            Spacer()
                        }
                        .padding(.leading, 20)
                        .padding(.vertical, 4)
                    }
                }

                // Interaction Buttons
                HStack {
                    Button(action: { isLiked.toggle() }) {
                        Label("Like", systemImage: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .gray)
                    }
                    Spacer()
                    Button(action: { isCommenting = true }) {
                        Label("Comment", systemImage: "message")
                            .foregroundColor(.gray)
                    }
                    .sheet(isPresented: $isCommenting) {
                        CommentModalView(
                            commentText: $commentText,
                            onCancel: { isCommenting = false },
                            onPost: { commentText in
                                // Add a new comment dynamically
                                let newComment = Comment(
                                    username: "Current User",
                                    profilePicture: "profile_placeholder", // Replace with actual profile picture
                                    text: commentText
                                )
                                comments.append(newComment) // Append the comment
                                isCommenting = false // Close modal
                            }
                        )
                    }
                    Spacer()
                    Button(action: { showShareSheet = true }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .font(.headline)
                    }
                    .sheet(isPresented: $showShareSheet) {
                        ShareSheet(items: [post.content])
                    }
                    .foregroundColor(.gray)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
            }
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
    


struct ChatFriend: Identifiable {
    let id = UUID()
    let username: String
    let profilePicture: String // Image name in asset catalog
    let lastMessage: String
}

struct MessagingView: View {
    let friends = [
        ChatFriend(username: "Nathaniel", profilePicture: "Nathaniel", lastMessage: ""),
        ChatFriend(username: "Yousri", profilePicture: "yousri", lastMessage: "See you at the gym!"),
        ChatFriend(username: "Luke", profilePicture: "Luke", lastMessage: "Let's plan for tomorrow."),
        ChatFriend(username: "Hassan", profilePicture: "Hassan", lastMessage: "Can you send me the file?")
    ]

    var body: some View {
        List(friends) { friend in
            NavigationLink(destination: ChatView(friend: friend)) {
                HStack {
                    // Profile Picture
                    Image(friend.profilePicture)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    
                    VStack(alignment: .leading) {
                        Text(friend.username)
                            .font(.headline)
                        Text(friend.lastMessage)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    Spacer()
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Messages")
    }
}


struct ChatView: View {
    let friend: ChatFriend
    @State private var messages: [Message] = [] // Start with an empty array
    @State private var newMessage = ""

    var body: some View {
        VStack {
            // Display Messages
            ScrollView {
                ForEach(messages) { message in
                    MessageBubble(message: message)
                }
            }
            .padding(.vertical)

            // Input Box for Sending Messages
            HStack {
                TextField("Type a message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .navigationTitle(friend.username)
    }

    // Function to Send a Message
    func sendMessage() {
        guard !newMessage.isEmpty else { return }

        // Add the user's message
        let userMessage = Message(sender: "You", content: newMessage, isCurrentUser: true)
        messages.append(userMessage)

        // Auto-reply logic
        if newMessage.lowercased() == "hi" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Delay to simulate typing
                let reply = Message(sender: friend.username, content: "Hi, how are you?", isCurrentUser: false)
                messages.append(reply)
            }
        }

        // Clear the input field
        newMessage = ""
    }
}


struct Message: Identifiable {
    let id = UUID()
    let sender: String
    let content: String
    let isCurrentUser: Bool
}

struct MessageBubble: View {
    let message: Message

    var body: some View {
        HStack {
            if message.isCurrentUser { Spacer() }
            
            Text(message.content)
                .padding(10)
                .background(message.isCurrentUser ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(message.isCurrentUser ? .white : .black)
                .cornerRadius(10)
            
            if !message.isCurrentUser { Spacer() }
        }
        .padding(.horizontal)
    }
}



struct CreatePostView: View {
    @State private var postText = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showingImagePicker = false
    @ObservedObject var postsManager: PostsManager
    @Environment(\.presentationMode) var presentationMode
    
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
                    Button(action: createPost){
                        Text("Post")
                            .font(.headline)
                            .foregroundColor(postText.isEmpty ? Color.gray : Color.orange)
                        
                    }
                    .disabled(postText.isEmpty) // Disable button if no text is entered
                }
            }
        }
    }
    
    func createPost() {
        guard !postText.isEmpty else { return }
        
        // Add the new post
        let newPost = Post(
            username: "Jane Doe",
            timeAge: "Just now",
            profilePicture: "JaneDoe", // Placeholder for now
            content: postText
        )
        
        postsManager.posts.insert(newPost, at: 0) // Add to the top of the feed
        postText = "" // Clear the text field
        presentationMode.wrappedValue.dismiss()
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
    SocialView()
}

