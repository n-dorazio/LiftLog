import SwiftUI
import Foundation
import Combine

class UserProfileModel: ObservableObject {
    @Published var name: String = "Jane Doe"
    @Published var bio: String = "Fitness enthusiast and cardio lover"
    @Published var topRoutines: [String] = ["Pull-ups", "Sit-ups", "Squats"]
    @Published var profileImageName: String = "JaneDoe"
    @Published var friends: [Friend] = [] {
        didSet { saveFriends() }
    }
    @Published var posts: [ExistingPosts] = [] {
        didSet { savePosts() }
    }

    init() {
        loadFriends()
        loadPosts()
    }

    // File paths
    private var friendsFileURL: URL {
        getDocumentsDirectory().appendingPathComponent("friends.json")
    }
    private var postsFileURL: URL {
        getDocumentsDirectory().appendingPathComponent("posts.json")
    }

    // saving functions
    func saveFriends() {
        do {
            let data = try JSONEncoder().encode(friends)
            try data.write(to: friendsFileURL)
        } catch {
            print("Error saving friends: \(error)")
        }
    }

    func savePosts() {
        do {
            let data = try JSONEncoder().encode(posts)
            try data.write(to: postsFileURL)
        } catch {
            print("Error saving posts: \(error)")
        }
    }

    // loading function
    func loadFriends() {
        do {
            let data = try Data(contentsOf: friendsFileURL)
            friends = try JSONDecoder().decode([Friend].self, from: data)
        } catch {
            print("Error loading friends: \(error)")
            // Initialize with default friends if needed
            friends = [
                Friend(id: "John Smith", name: "John Smith", image: "jordan"),
                Friend(id: "Alice Johnson", name: "Alice Johnson", image: "kate"),
                Friend(id: "Christie", name: "Christie", image: "christie")
            ]
        }
    }

    func loadPosts() {
        do {
            let data = try Data(contentsOf: postsFileURL)
            posts = try JSONDecoder().decode([ExistingPosts].self, from: data)
        } catch {
            print("Error loading posts: \(error)")
            // Initialize with default posts if needed
            posts = [defaultPost]
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    // a default post
    var defaultPost: ExistingPosts {
        ExistingPosts(
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
    }
}
