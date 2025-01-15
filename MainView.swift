//
//  MainView.swift
//  SentiApp
//
//  Created by Chloe Sepulveda on 2025-01-14.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// #Preview {
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Order())
    }
}
