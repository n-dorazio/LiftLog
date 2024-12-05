//
//  SettingsView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-22.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userProfile: UserProfileModel
    @ObservedObject var settings: SettingsStore
    
    // Local view state
    @State private var showEditProfile = false
    @State private var showEditWeight = false
    @State private var showEditGender = false
    @State private var showEditBirthday = false
    @State private var showEditUsername = false
    @State private var showEditPassword = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Profile Image
                    VStack(spacing: 8) {
                        Button(action: {
                            showEditProfile = true
                        }) {
                            Image(userProfile.profileImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(
                                    Image(systemName: "pencil.circle.fill")
                                        .foregroundColor(.blue)
                                        .offset(x: 35, y: 35)
                                )
                        }
                        
                        Text(userProfile.name)
                            .font(.title2)
                            .bold()
                    }
                    .padding(.bottom)
                    
                    VStack(spacing: 12) {
                        Text("Settings")
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // App Settings
                        ToggleSettingRow(icon: "eye", title: "Profile Public", isOn: $settings.isProfilePublic, isHighlighted: true)
                        ToggleSettingRow(icon: "square.and.arrow.up", title: "Auto Share Workouts", isOn: $settings.autoShareWorkouts, isHighlighted: true)
                        ToggleSettingRow(icon: "bell", title: "Notifications", isOn: $settings.notifications, isHighlighted: true)
                        ToggleSettingRow(icon: "bed.double", title: "Rest Day Reminders", isOn: $settings.restDayReminders, isHighlighted: true)
                        ToggleSettingRow(icon: "drop", title: "Water Intake Reminders", isOn: $settings.waterIntakeReminders, isHighlighted: true)
                        ToggleSettingRow(icon: "bell", title: "Daily Workout Reminders", isOn: $settings.workoutReminders, isHighlighted: true)
                        EditableSettingRow(icon: "dumbbell", title: "Weight", value: settings.weight + " lbs", screenState: $showEditWeight)
                        EditableSettingRow(icon: "person", title: "Gender", value: settings.gender, screenState: $showEditGender)
                        
                        Spacer()
                            .frame(height: 30)
                        
                        Text("Account")
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Account Settings
                        EditableSettingRow(icon: "birthday.cake", title: "Birthday", value: settings.birthday, screenState: $showEditBirthday)
                        EditableSettingRow(icon: "person", title: "Username", value: settings.username, screenState: $showEditUsername)
                        EditableSettingRow(icon: "lock", title: "Password", value: settings.password, screenState: $showEditPassword)
                        
                        // Logout Button
                        VStack(spacing: 12) {
                            Button(action: {
                                // Handle logout action
                            }) {
                                Text("LOGOUT")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        LinearGradient(colors: [.red, .orange],
                                                       startPoint: .leading,
                                                       endPoint: .trailing)
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationBarHidden(true)
        }
        // Update the sheets to pass settings if needed
        .sheet(isPresented: $showEditProfile) {
            EditProfileView(userProfile: userProfile)
        }
        .sheet(isPresented: $showEditWeight) {
            EditWeightView(settings: settings)
        }
        .sheet(isPresented: $showEditGender) {
            EditGenderView(settings: settings)
        }
        .sheet(isPresented: $showEditBirthday) {
            EditBirthdayView(settings: settings)
        }
        .sheet(isPresented: $showEditUsername) {
            EditUsernameView(settings: settings)
        }
        .sheet(isPresented: $showEditPassword) {
            EditPasswordView(settings: settings)
        }
    }
}

struct ToggleSettingRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    var isHighlighted: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 30)
            Text(title)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.orange)
        }
        .padding()
        .background(isOn ? Color.orange : Color.gray.opacity(0.2))
        .foregroundColor(isOn ? .white : .black)
        .cornerRadius(15)
    }
}

struct EditBirthdayView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var settings: SettingsStore
    @State private var birthdayInput: String = ""

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                Spacer()
            }
            .padding(.horizontal)
            
            Text("Edit Birthday")
                .font(.title)
                .bold()
                .padding()

            TextField("Enter your birthday", text: $birthdayInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                settings.birthday = birthdayInput
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .onAppear {
            birthdayInput = settings.birthday
        }
    }
}

struct EditGenderView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var settings: SettingsStore
    @State private var genderInput: String = ""

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                Spacer()
            }
            .padding(.horizontal)
            
            Text("Edit Gender")
                .font(.title)
                .bold()
                .padding()

            TextField("Enter your gender", text: $genderInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                settings.gender = genderInput
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .onAppear {
            genderInput = settings.gender
        }
    }
}

struct EditUsernameView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var settings: SettingsStore
    @State private var usernameInput: String = ""

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                Spacer()
            }
            .padding(.horizontal)
            
            Text("Edit Username")
                .font(.title)
                .bold()
                .padding()

            TextField("Enter your username", text: $usernameInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                settings.username = usernameInput
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .onAppear {
            usernameInput = settings.username
        }
    }
}

struct EditPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var settings: SettingsStore
    @State private var passwordInput: String = ""

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                Spacer()
            }
            .padding(.horizontal)
            
            Text("Edit Password")
                .font(.title)
                .bold()
                .padding()

            SecureField("Enter your password", text: $passwordInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                settings.password = passwordInput
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .onAppear {
            passwordInput = settings.password
        }
    }
}

struct EditableSettingRow: View {
    let icon: String
    let title: String
    let value: String
    @Binding var screenState: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 30)
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
            Button(action: {
                screenState = true
            }) {
                Image(systemName: "pencil")
                    .foregroundColor(.gray)
            }
            
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(15)
    }
}

#Preview {
    let mockUserProfile = UserProfileModel()
    let mockSettings = SettingsStore()
    SettingsView(userProfile: mockUserProfile, settings: mockSettings)
}
