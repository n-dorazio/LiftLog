//
//  HomeView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-21.
//
//

import SwiftUI

struct HomeView: View {
    @State private var showCalendar = false
    @State private var showDetailsModal = false
    @State private var selectedDate = Date()

    @StateObject private var userProfile = UserProfileModel()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMM"
        return formatter
    }()
    
    var formattedDate: String {
        return dateFormatter.string(from: selectedDate)
    }

    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with profile and date
                        HStack {
                            HStack(spacing: 12) {
                                NavigationLink(destination: ProfileView(userProfile: userProfile)) {
                                    if let imageURL = userProfile.imageURL(),
                                       let imageData = try? Data(contentsOf: imageURL),
                                       let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                            .shadow(radius: 5)
                                    } else {
                                        // Fallback to default image
                                        Image("JaneDoe")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                            .shadow(radius: 5)
                                    }
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("Hello \(userProfile.name)!")
                                        .foregroundColor(.gray)
                                    Text(formattedDate)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    showCalendar.toggle()
                                }
                            }) {
                                Image(systemName: "calendar")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                    .padding(12)
                                    .background(Circle().fill(Color.white))
                                    .shadow(color: .gray.opacity(0.2), radius: 5)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Calories Card
                        VStack(spacing: 16) {
                            
                            Text("Total Kilocalories")
                                .foregroundColor(.gray)
                            HStack {
                                Text("1,883")
                                    .font(.system(size: 40, weight: .bold))
                                Text("/ 2,500 Kcal")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                
                            }
                            
                            
                            // Progress bars
                            HStack(spacing: 30) {
                                VStack(alignment: .leading) {
                                    Text("7.5 km")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                    Text("Distance")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("9832")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                        Text("/ 10,000")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.gray)
                                    }
                                    Text("Steps")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: .gray.opacity(0.1), radius: 10)
                        )
                        .padding(.horizontal)
                        .onTapGesture {
                                withAnimation {
                                showDetailsModal.toggle()
                            }
                        }
                        // Exercise Cards
                        HStack(spacing: 15) {
                            ExerciseCard(icon: "dumbbell.fill", calories: "70 lbs", title: "Dumbbell")
                            ExerciseCard(icon: "figure.walk", calories: "235 Kcal", title: "Treadmill")
                            ExerciseCard(icon: "figure.jumprope", calories: "432 Kcal", title: "Rope")
                        }
                        .padding(.horizontal)
                        
                        // My Plan Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("My Plan")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("December, 2024")
                                .foregroundColor(.gray)
                            
                            WorkoutPlanCard()
                                .padding(.top, 8)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .background(Color.gray.opacity(0.05))
                
                
                // Calendar Popup
                if showCalendar {
                    VStack {
                        CalendarView(selectedDate: $selectedDate) {
                            withAnimation {
                                showCalendar = false
                            }
                        }
                        .background(
                            Color.white
                                .cornerRadius(20)
                                .shadow(radius: 10)
                        )
                        .padding()
                        .transition(.scale(scale: 0.95))
                        
                        Spacer()
                    }
                    .background(
                        Color.black.opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    showCalendar.toggle()
                                }
                            }
                    )
                }
            }
        }
    }
}



struct ExerciseCard: View {
    let icon: String
    let calories: String
    let title: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                )
            
            Text("\(calories)")
                .fontWeight(.semibold)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.1), radius: 5)
        )
    }
}

struct WorkoutPlanCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 15) {
                Circle()
                    .fill(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "bolt.fill")
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("WEEK 1")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("Body Weight")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Workout 1 of 5")
                        .font(.caption)
                }
            }
            
            HStack {
                Image(systemName: "play.fill")
                Text("Next exercise")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("Lower Strength")
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(10)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(20)
    }
}

#Preview {
    ContentView()
}

