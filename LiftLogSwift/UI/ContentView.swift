//
//  ContentView.swift
//  LiftLogSwift
//
//  Created by Nathaniel D'Orazio on 2024-11-21.
//
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 2
    
    var body: some View {
        TabView (selection: $selectedTab){
            LogView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Log")
                }
                .tag(0)
            
            WorkoutView()
                .tabItem {
                    Image(systemName: "figure.run")
                    Text("Workout")
                }
                .tag(1)
            
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(2)
            
            SocialView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Social")
                }
                .tag(3)
            
            NutritionView()
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Nutrition")
                }
                .tag(4)
        }
        .accentColor(.orange)
    }
}

#Preview {
    ContentView()
}
