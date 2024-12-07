import SwiftUI
import Foundation
import Combine

class UserProfileModel: ObservableObject {
    
    @Published var suggestedFriends: [Friend] = [
        Friend(id: "John Smith", name: "John Smith", image: "jordan"),
        Friend(id: "Alice Johnson", name: "Alice Johnson", image: "kate"),
        Friend(id: "Christie", name: "Christie", image: "christie")
    ]
    
    @Published var name: String = "Jane Doe" {
        didSet { saveUserProfile() }
    }
    @Published var bio: String = "Fitness enthusiast and cardio lover" {
        didSet { saveUserProfile() }
    }
    @Published var topRoutines: [String] = ["Pull-ups", "Sit-ups", "Squats"] {
        didSet { saveUserProfile() }
    }
    @Published var profileImageName: String = "JaneDoe" {
        didSet {
            UserDefaults.standard.set(profileImageName, forKey: "profileImageName")
            saveUserProfile()
        }
    }
    @Published var friends: [Friend] = [] {
        didSet {
            saveFriends()
            saveUserProfile()
        }
    }
    @Published var posts: [ExistingPosts] = [] {
        didSet {
            savePosts()
            saveUserProfile()
        }
    }
    
    // We'll create a separate struct for encoding/decoding name, bio, routines
    struct UserProfileData: Codable {
        let name: String
        let bio: String
        let topRoutines: [String]
        let profileImageName: String
    }

    init() {
        loadUserProfile()
        loadFriends()
        loadPosts()
        
        if posts.isEmpty {
            posts = [defaultPost]
        }
        
        if let savedImageName = UserDefaults.standard.string(forKey: "profileImageName") {
            profileImageName = savedImageName
        }
    }

    func imageURL() -> URL? {
        if profileImageName == "JaneDoe" {
            return nil
        }
        return getDocumentsDirectory().appendingPathComponent(profileImageName)
    }

    // MARK: - File URLs
    private var friendsFileURL: URL {
        getDocumentsDirectory().appendingPathComponent("friends.json")
    }

    private var postsFileURL: URL {
        getDocumentsDirectory().appendingPathComponent("posts.json")
    }
    
    private var userProfileFileURL: URL {
        getDocumentsDirectory().appendingPathComponent("userProfile.json")
    }

    // MARK: - Save/Load Functions
    func saveFriends() {
        do {
            let data = try JSONEncoder().encode(friends)
            try data.write(to: friendsFileURL)
        } catch {
            print("Error saving friends: \(error)")
        }
    }

    func loadFriends() {
        do {
            let data = try Data(contentsOf: friendsFileURL)
            friends = try JSONDecoder().decode([Friend].self, from: data)
        } catch {
            print("Error loading friends: \(error)")
            friends = [
                Friend(id: "John Smith", name: "John Smith", image: "jordan"),
                Friend(id: "Alice Johnson", name: "Alice Johnson", image: "kate"),
                Friend(id: "Christie", name: "Christie", image: "christie")
            ]
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

    func loadPosts() {
        do {
            let data = try Data(contentsOf: postsFileURL)
            posts = try JSONDecoder().decode([ExistingPosts].self, from: data)
        } catch {
            print("Error loading posts: \(error)")
            posts = [defaultPost]
        }
    }

    // Save user profile data (name, bio, topRoutines, profileImageName)
    func saveUserProfile() {
        let userData = UserProfileData(
            name: name,
            bio: bio,
            topRoutines: topRoutines,
            profileImageName: profileImageName
        )
        
        do {
            let data = try JSONEncoder().encode(userData)
            try data.write(to: userProfileFileURL)
        } catch {
            print("Error saving user profile: \(error)")
        }
    }

    func loadUserProfile() {
        do {
            let data = try Data(contentsOf: userProfileFileURL)
            let userData = try JSONDecoder().decode(UserProfileData.self, from: data)
            self.name = userData.name
            self.bio = userData.bio
            self.topRoutines = userData.topRoutines
            self.profileImageName = userData.profileImageName
        } catch {
            print("Error loading user profile: \(error)")
            // If fails, use defaults
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    var defaultPost: ExistingPosts {
        ExistingPosts(
            id: UUID(),
            username: "Jane Doe",
            timeAgo: "2d ago",
            content: "Hey Pookies! Just started using this amazing app called LiftLog. Now my fitness goals seem achievable!!",
            likes: 121,
            isLiked: false,
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
