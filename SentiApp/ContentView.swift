//
//  ContentView.swift
//  SentiApp
//
//  Created by Chloe Sepulveda on 2025-01-04.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        
        // I'm doing this because of ..
        // Watch out for this ..
        VStack {
           
            //Image for the plant
            Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                .resizable()
                .frame(width: 260.0, height: 260.0)
                .cornerRadius(20)
            /*print("Hi")*/
            Text("BizTrendX")
                .font(.system(size: 30, weight: .heavy, design: .default))
                
                .bold()
                .padding(.top, 13.0)
                .padding(.bottom, 18.0)
                .cornerRadius(10)
            
              Button("Tap to start")
            {
             print("Helo!")
             }
            .buttonStyle(.borderedProminent)
            .font(Font.system(size: 25))
            .tint(Color(hue: 0.705, saturation: 0.964, brightness: 0.474))
        }
        .padding()
    }
}

// MARK: - This is for previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
