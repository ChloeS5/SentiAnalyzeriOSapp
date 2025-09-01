//
//  MainView.swift
//  SentiApp
//
//  Created by Chloe Sepulveda on 2025-01-14.
//
// File Purpose: Switching tabs

import SwiftUI

// defind Order to prevent "Cannot find order in scope" issue
class Order: ObservableObject {
}


struct MainView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Menue", systemImage: "list.dash")
                }
            
            // TASK: create a AnalyzeView page to refer to this
            AnalyzeView()
                .tabItem {
                    Label("Analyze", systemImage: "text.page.badge.magnifyingglass")
                }
            
            DataDashboard()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.xaxis.ascending")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

// #Preview {
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AppState())
    }
}
