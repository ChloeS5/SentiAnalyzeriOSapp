//
//  SentiAppApp.swift
//  SentiApp
//
//  Created by Chloe Sepulveda on 2025-01-04.
//

import SwiftUI

@main
struct SentiAppApp: App {
    @StateObject var order = Order()
    
    var body: some Scene {
        WindowGroup {
            //Now MainView is initial view in-app
            MainView()
                .environmentObject(order)
           // ContentView()
        }
    }
}
