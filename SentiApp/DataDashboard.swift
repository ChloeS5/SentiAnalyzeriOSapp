//
//  DataDashboard.swift
//  SentiApp
//
//  Created by Chloe Sepulveda on 2025-01-26.
//
import SwiftUI
import Charts

// MARK: - ViewModels (demo stubs — replace with real data later)

final class QuizVM: ObservableObject {
    struct TagStat: Identifiable { let id = UUID(); let tag: String; let accuracy: Double }
    @Published var tagStats: [TagStat] = [
        .init(tag: "NLP", accuracy: 0.82),
        .init(tag: "Vision", accuracy: 0.76)
    ]
    struct LeaderRow: Identifiable { let id = UUID(); let user: String; let score: Int }
    @Published var leaderboard: [LeaderRow] = [
        .init(user: "You", score: 120), .init(user: "Ava", score: 110)
    ]
}

final class EventsVM: ObservableObject {
    @Published var municipality: String? = "Vancouver"
    @Published var events: [String] = ["Town Hall", "Budget Hearing"]
}

final class NewsVM: ObservableObject {
    @Published var items: [String] = ["Policy X passed", "New bylaw proposed"]
}

// MARK: - Dashboard

struct DataDashboard: View {
    @StateObject private var quizVM   = QuizVM()
    @StateObject private var eventsVM = EventsVM()
    @StateObject private var newsVM   = NewsVM()

    let viewMonths: [SalesMonth] = [
        .init(date: Date.from(year: 2025, month: 1, day: 1), salesCount: 55_000),
        .init(date: Date.from(year: 2025, month: 2, day: 1), salesCount: 65_000),
        .init(date: Date.from(year: 2025, month: 3, day: 1), salesCount: 72_000),
        .init(date: Date.from(year: 2025, month: 4, day: 1), salesCount: 76_000),
        .init(date: Date.from(year: 2025, month: 5, day: 1), salesCount: 83_000),
        .init(date: Date.from(year: 2025, month: 6, day: 1), salesCount: 89_000),
        .init(date: Date.from(year: 2025, month: 7, day: 1), salesCount: 123_000)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    header

                    BusinessTrendsCard(data: viewMonths)
                   //PerformanceCardsPlaceholder()
                     //   .glassCard()
                    
                    LeaderboardCard(entries: quizVM.leaderboard)
                        .glassCard()
                    RecommendationCard(vm: eventsVM)
                        .glassCard()

//                    TagAccuracyCard(stats: quizVM.tagStats)
//                        .glassCard()
//                   
//                    NewsFeedCard(vm: newsVM)
//                        .glassCard()

                    
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
                .frame(maxWidth: 600) // keep all cards same width, center aligned
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Dashboard")
        }
        .background(
            LinearGradient(
                colors: [Color.black, Color.indigo.opacity(0.4)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Welcome")
                .font(.system(size: 34, weight: .black))   // bigger
                .foregroundStyle(.primary)
            if let muni = eventsVM.municipality, !muni.isEmpty {
                Text(muni)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)   // top-left
    }
}

//private struct PerformanceCardsPlaceholder: View {
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text("Stats").font(.headline)
//                Text("1,245").font(.title).bold()
//            }
//            Spacer()
//            VStack(alignment: .leading) {
//                Text("Conversion").font(.headline)
//                Text("7.9%").font(.title).bold()
//            }
//        }
//        .padding(16)
//    }
//}

struct BusinessTrendsCard: View {
    let data: [SalesMonth]

    @State private var selectedDate: Date? = nil
    @State private var selectedValue: Int? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Business Trends")
                .font(.headline)
            Text("Monthly views")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Chart {
                ForEach(data) { m in
                    BarMark(
                        x: .value("Month", m.date, unit: .month),
                        y: .value("Views", m.salesCount)
                    )
                    .cornerRadius(6)
                    .opacity(selectedDate == nil || Calendar.current.isDate(m.date, equalTo: selectedDate ?? Date.distantPast, toGranularity: .month) ? 1 : 0.35)
                }

                if let d = selectedDate, let v = selectedValue {
                    RuleMark(x: .value("Selected", d))
                        .foregroundStyle(.indigo)
                        .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [4,4]))

                    PointMark(x: .value("Selected", d), y: .value("Views", v))
                        .foregroundStyle(.indigo)
                        .annotation(position: .topLeading) {   // ✅ use .annotation here
                            Text("\(d, format: .dateTime.month(.abbreviated))  \(v.formatted())")
                                .font(.caption.monospaced())
                                .padding(.horizontal, 8).padding(.vertical, 4)
                                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 6))
                        }
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) { _ in
                    AxisValueLabel(format: .dateTime.month(.abbreviated))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(height: 230)
            .foregroundStyle(.indigo.gradient)
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let origin = geo[proxy.plotAreaFrame].origin
                                    let location = CGPoint(
                                        x: value.location.x - origin.x,
                                        y: value.location.y - origin.y
                                    )
                                    if let date: Date = proxy.value(atX: location.x) {
                                        if let nearest = data.min(by: {
                                            abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date))
                                        }) {
                                            selectedDate = nearest.date
                                            selectedValue = nearest.salesCount
                                        }
                                    }
                                }
                        )
                }
            }
        }
        .glassCard()
    }
}








struct TagAccuracyCard: View {
    let stats: [QuizVM.TagStat]
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tag Accuracy").font(.headline)
            ForEach(stats) { s in
                HStack {
                    Text(s.tag)
                    Spacer()
                    Text("\(Int(s.accuracy * 100))%").monospacedDigit()
                }
            }
        }
        .padding(16)
    }
}

struct LeaderboardCard: View {
    let entries: [QuizVM.LeaderRow]
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Stats").font(.title)
            ForEach(entries) { e in
                HStack { Text(e.user); Spacer(); Text("\(e.score)") }
            }
        }
        .padding(16)
    }
}

struct RecommendationCard: View {
    @ObservedObject var vm: EventsVM
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recommendations                                              ").font(.title)
            ForEach(vm.events, id: \.self) { e in Text("• \(e)") }
        }
        .padding(16)
    }
}

struct NewsFeedCard: View {
    @ObservedObject var vm: NewsVM
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Trends").font(.headline)
            ForEach(vm.items, id: \.self) { n in Text("• \(n)") }
        }
        .padding(16)
    }
}

// Styling helpers
extension View {
    func glassCard() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.indigo.opacity(0.9),
                                Color.purple.opacity(0.6),
                                Color.indigo.opacity(0.9)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.6
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .indigo.opacity(0.3), radius: 20, y: 10)
    }
}

// Chart data types

struct SalesMonth: Identifiable {
    let id = UUID()
    let date: Date
    let salesCount: Int
}

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!
    }
}

// Preview

struct DataDashboard_Previews: PreviewProvider {
    static var previews: some View {
        DataDashboard()
            .preferredColorScheme(.light) //dark vs light mode
    }
}


