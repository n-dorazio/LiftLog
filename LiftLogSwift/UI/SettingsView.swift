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
    @State private var isProfilePublic = false
    @State private var autoShareWorkouts = false
    @State private var notifications = true
    @State private var restDayReminders = false
    @State private var waterIntakeReminders = false
    @State private var workoutReminders = true
    @State private var weight = "140 lbs"
    @State private var gender = "Female"
    @State private var birthday = "11/03/2003"
    @State private var username = "JaneDoe123"
    @State private var password = "•••••••••"
    @State private var showAccountOptions = false
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
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "pencil.circle.fill")
                                        .foregroundColor(.blue)
                                        .offset(x: 35, y: 35)
                                )
                        }
                        
                        Text("Jane Doe")
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
                        ToggleSettingRow(icon: "eye", title: "Profile Public", isOn: $isProfilePublic, isHighlighted: true)
                        ToggleSettingRow(icon: "square.and.arrow.up", title: "Auto Share Workouts", isOn: $autoShareWorkouts, isHighlighted: true)
                        ToggleSettingRow(icon: "bell", title: "Notifications", isOn: $notifications, isHighlighted: true)
                        ToggleSettingRow(icon: "bed.double", title: "Rest day Reminders", isOn: $restDayReminders, isHighlighted: true)
                        ToggleSettingRow(icon: "drop", title: "Water Intake Reminders", isOn: $waterIntakeReminders, isHighlighted: true)
                        ToggleSettingRow(icon: "bell", title: "Daily Workout Reminders", isOn: $workoutReminders, isHighlighted: true)
                        EditableSettingRow(icon: "dumbbell", title: "Weight", value: weight, screenState: $showEditWeight)
                        EditableSettingRow(icon: "person", title: "Gender", value: gender, screenState: $showEditGender)
                        
                        // Spacer or Padding
                        Spacer()
                            .frame(height: 30)
                        
                        Text("Account")
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Account Settings
                        EditableSettingRow(icon: "birthday.cake", title: "Birthday", value: birthday, screenState: $showEditBirthday)
                        EditableSettingRow(icon: "person", title: "Username", value: username, screenState: $showEditUsername)
                        EditableSettingRow(icon: "lock", title: "Password", value: password, screenState: $showEditPassword)
                        
                        // Account Switch Section
                        DisclosureGroup(
                            isExpanded: $showAccountOptions,
                            content: {
                                VStack(spacing: 12) {
                                    Button(action: {}) {
                                        Text("Switch to: JaneBackupAcc")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color.gray.opacity(0.3))
                                            .cornerRadius(10)
                                    }
                                    
                                    Button(action: {}) {
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
                            },
                            label: {
                                HStack {
                                    Image(systemName: "person.circle")
                                        .frame(width: 30)
                                    Text("Switch Account")
                                    Spacer()
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(15)
                            }
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showEditProfile) {
            EditProfileView(userProfile: userProfile)
        }
        .sheet(isPresented: $showEditWeight) {
            EditProfileView(userProfile: userProfile)
        }
        .sheet(isPresented: $showEditGender) {
            EditProfileView(userProfile: userProfile)
        }
        .sheet(isPresented: $showEditBirthday) {
            EditProfileView(userProfile: userProfile)
        }
        .sheet(isPresented: $showEditUsername) {
            EditProfileView(userProfile: userProfile)
        }
        .sheet(isPresented: $showEditPassword) {
            EditProfileView(userProfile: userProfile)
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

