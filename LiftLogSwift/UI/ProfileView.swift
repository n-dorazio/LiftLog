//
//  ProfileView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-21.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showSettings = false
    @State private var showAddFriends = false
    @StateObject private var userProfile = UserProfileModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                HStack {
                    Spacer()
                    Text(userProfile.name)
                        .font(.title2)
                        .bold()
                    Spacer()
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gearshape")
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                
                // Profile Image and Stats
                VStack(spacing: 20) {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 100, height: 100)
                    
                    HStack(spacing: 40) {
                        VStack {
                            Text("2")
                                .font(.title2)
                                .bold()
                            Text("Posts")
                                .foregroundColor(.gray)
                        }
                        
                        VStack {
                            Text("124")
                                .font(.title2)
                                .bold()
                            Text("Friends")
                                .foregroundColor(.gray)
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
                        likes: "121",
                        comments: "34"
                    )
                }
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showSettings) {
            SettingsView(userProfile: userProfile)
        }
        .sheet(isPresented: $showAddFriends) {
            AddFriendsView()
        }
    }
}

struct SocialPostProfile: View {
    let username: String
    let timeAgo: String
    let content: String
    let likes: String
    let comments: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 40, height: 40)
                
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
            
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(height: 200)
                .cornerRadius(12)
            
            HStack(spacing: 30) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "heart")
                        Text(likes)
                    }
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "bubble.right")
                        Text(comments)
                    }
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share")
                }
            }
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.1), radius: 5)
    }
}

#Preview {
    ProfileView()
}

