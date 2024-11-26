//
//  EditProfileView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userProfile: UserProfileModel
    @State private var tempName: String
    @State private var tempBio: String
    @State private var tempRoutines: [String]
    
    init(userProfile: UserProfileModel) {
        self.userProfile = userProfile
        _tempName = State(initialValue: userProfile.name)
        _tempBio = State(initialValue: userProfile.bio)
        _tempRoutines = State(initialValue: userProfile.topRoutines)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Profile Image
                VStack(spacing: 8) {
                    Image("JaneDoe")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 2)
                        )
                    
                    Button("Edit Picture") {
                        // Handle image picker
                    }
                    .foregroundColor(.blue)
                }
                
                Divider()
                
                // Name Field
                VStack(alignment: .leading) {
                    Text("Name")
                        .bold()
                    TextField("Enter name", text: $tempName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                // Bio Field
                VStack(alignment: .leading) {
                    Text("Bio")
                        .bold()
                    TextField("Enter bio", text: $tempBio)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                // Top Routines
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Top Routines")
                            .bold()
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "pencil")
                        }
                    }
                    
                    ForEach(tempRoutines, id: \.self) { routine in
                        HStack {
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
                            
                            Spacer()
                            
                            Button(action: {
                                if let index = tempRoutines.firstIndex(of: routine) {
                                    tempRoutines.remove(at: index)
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    userProfile.name = tempName
                    userProfile.bio = tempBio
                    userProfile.topRoutines = tempRoutines
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .navigationBarTitle("Edit Profile", displayMode: .inline)
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(userProfile: UserProfileModel())
    }
}
