//
//  DataDashboard.swift
//  SentiApp
//
//  Created by Chloe Sepulveda on 2025-01-26.
//
import SwiftUI
import Charts

struct DataDashboard: View {
    
    let viewMonths: [SalesMonth] = [
        .init(date: Date.from(year: 2025, month: 1, day: 1), salesCount: 55000),
        .init(date: Date.from(year: 2025, month: 2, day: 1), salesCount: 65000),
        .init(date: Date.from(year: 2025, month: 3, day: 2), salesCount: 72000),
        .init(date: Date.from(year: 2025, month: 3, day: 2), salesCount: 76000),
        .init(date: Date.from(year: 2025, month: 3, day: 2), salesCount: 83000),
        .init(date: Date.from(year: 2025, month: 3, day: 2), salesCount: 89000),
        .init(date: Date.from(year: 2025, month: 3, day: 2), salesCount: 123000)
    ]
    
    var body: some View {
        VStack {
            Chart {
                ForEach(viewMonths) { viewMonth in
                    BarMark(
                        x: .value("Views", viewMonth.salesCount),
                        y: .value("Month", viewMonth.date, unit: .month)
                        
                            )}
            }
            .foregroundStyle(Color.blue.gradient)
            .cornerRadius(15)
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text("Hi World!")
            .frame(height: 200)
        }
        .padding()
    }
}

struct SalesView_Previews: PreviewProvider {
    static var previews: some View {
        DataDashboard()
    }
}
    
    struct SalesMonth: Identifiable {
        let id = UUID()
        let date: Date //x-axis
        let salesCount: Int // y-xas
    }

    extension Date {
        static func from(year: Int, month: Int, day: Int) -> Date {
            let components = DateComponents(year: year, month: month, day: day)
            return Calendar.current.date(from: components)!
        }
    }
    
    
    


