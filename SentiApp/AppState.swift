//
//  AppState.swift
//  SentiApp
//
//  Created by Chloe Sepulveda on 2025-08-29.
//

import SwiftUI

enum MainTab: Hashable {
    case menu, games, dashboard, settings, quiz
}

final class AppState: ObservableObject {
    @Published var selectedTab: MainTab = .menu
}
