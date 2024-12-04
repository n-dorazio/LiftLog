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
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with profile and date
                        HStack {
                            HStack(spacing: 12) {
                                NavigationLink(destination: ProfileView()) {
                                    Image("JaneDoe")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle().stroke(Color.white, lineWidth: 2)
                                        )
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("Hello Jane!")
                                        .foregroundColor(.gray)
                                    Text("Friday, 08 Nov")
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
                            Text("1,883 Kcal")
                                .font(.system(size: 40, weight: .bold))
                            Text("Total Kilocalories")
                                .foregroundColor(.gray)
                            
                            // Progress bars
                            HStack(spacing: 30) {
                                VStack(alignment: .leading) {
                                    Text("7580 m")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                    Text("Distance")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("9832")
                                        .font(.title3)
                                        .fontWeight(.semibold)
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
                        .onTapGesture { // Tap gesture to trigger modal
                                withAnimation {
                                showDetailsModal.toggle()
                            }
                        }
                        // Exercise Cards
                        HStack(spacing: 15) {
                            ExerciseCard(icon: "dumbbell.fill", calories: "628", title: "Dumbbell")
                            ExerciseCard(icon: "figure.walk", calories: "235", title: "Treadmill")
                            ExerciseCard(icon: "figure.jumprope", calories: "432", title: "Rope")
                        }
                        .padding(.horizontal)
                        
                        // My Plan Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("My Plan")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("July, 2021")
                                .foregroundColor(.gray)
                            
                            WorkoutPlanCard()
                                .padding(.top, 8)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .background(Color.gray.opacity(0.05))
                
                // Details Modal
                if showDetailsModal {
                    DetailsModalView(showDetailsModal: $showDetailsModal)
                        .padding()
                        .transition(.scale(scale: 0.95))
                        .background(
                            Color.black.opacity(0.3)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    withAnimation {
                                        showDetailsModal.toggle()
                                    }
                                }
                        )
                }
                
                
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


// New View for Details Modal
struct DetailsModalView: View {
    @Binding var showDetailsModal: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Close Button
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        showDetailsModal.toggle()
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            // Modal Content
            Text("Daily Details")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Calories: 1,883 out of 2,500 kcal")
                    .font(.headline)
                Text("Distance: 7.5 km")
                    .font(.headline)
                Text("Steps: 9,832 out of 10,000")
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.2), radius: 5)
            )
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height:400)
        .background(Color.white)
        .cornerRadius(20)
//        .shadow(radius: 10)
    }
}



struct CalendarView: View {
    @Binding var selectedDate: Date
    var onClose: (() -> Void)? // Closure to handle the close action
    
    var body: some View {
        VStack {
            // Header with close button
            HStack {
                Text("Select a Date")
                    .font(.title2)
                    .padding()
                
                Spacer()
                
                // Close button
                Button(action: {
                    onClose?()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            
            // Date Picker
            DatePicker(
                "Date",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
            
            Spacer()
            
            // Done Button
            Button(action: {
                onClose?()
            }) {
                Text("Done")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Capsule().fill(Color.orange))
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .padding()
        .frame(height: 500)
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
            
            Text("\(calories) Kcal")
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

