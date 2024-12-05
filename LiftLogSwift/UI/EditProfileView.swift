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

    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil

    init(userProfile: UserProfileModel) {
        self.userProfile = userProfile
        _tempName = State(initialValue: userProfile.name)
        _tempBio = State(initialValue: userProfile.bio)
        _tempRoutines = State(initialValue: userProfile.topRoutines)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Profile Image Section
                VStack(spacing: 8) {
                    if let uiImage = selectedImage {
                        // Show the selected image if the user picked a new one
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    } else {
                        // If no new image is selected, try to load from userProfile.imageURL()
                        if let imageURL = userProfile.imageURL(),
                           let imageData = try? Data(contentsOf: imageURL),
                           let uiImage = UIImage(data: imageData) {
                            // Load saved custom image
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        } else {
                            // Fallback to default image
                            Image("JaneDoe")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        }
                    }

                    Button("Edit Picture") {
                        showImagePicker = true
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

                    // If user picked a new image
                    if let newImage = selectedImage {
                        if let imageName = saveImageToDocuments(image: newImage) {
                            userProfile.profileImageName = imageName
                        }
                    }

                    presentationMode.wrappedValue.dismiss()
                }
            )
            .navigationBarTitle("Edit Profile", displayMode: .inline)
            .sheet(isPresented: $showImagePicker) {
                ImagePickerDuplicate(selectedImage: $selectedImage)
            }
        }
    }

    private func saveImageToDocuments(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let filename = "profileImage.jpg"
        if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsURL.appendingPathComponent(filename)
            do {
                try data.write(to: fileURL, options: .atomic)
                return filename
            } catch {
                print("Error saving image: \(error)")
                return nil
            }
        }
        return nil
    }
}
struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(userProfile: UserProfileModel())
    }
}
