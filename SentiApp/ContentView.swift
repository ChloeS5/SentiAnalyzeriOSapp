//
//  ContentView.swift
//  SentiApp
//
//  Created by Chloe Sepulveda on 2025-01-04.
//
import SwiftUI

// MARK: - ContentView (Menu → morph → droplet → Analyze)

struct ContentView: View {
    @EnvironmentObject private var appState: AppState
    @Namespace private var animNS

    @State private var isCollapsing = false
    @State private var showDroplet = false
    @State private var isSpinning = false

    var body: some View {
        ZStack {
            // Main content
            VStack(spacing: 20) {
                Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                    .resizable()
                    .frame(width: 260, height: 260)
                    .cornerRadius(20)
                    .opacity(isCollapsing ? 0 : 1)
                    .animation(.easeInOut(duration: 0.25), value: isCollapsing)

                Text("BizTrendX")
                    .font(.system(size: 30, weight: .heavy))
                    .opacity(isCollapsing ? 0 : 1)
                    .animation(.easeInOut(duration: 0.25), value: isCollapsing)

                // CTA button that morphs
                if !isCollapsing {
                    Button(action: start) {
                        Text("Tap to start")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 22)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color.indigo)
                                    .matchedGeometryEffect(id: "buttonBG", in: animNS) // SOURCE
                            )
                    }.buttonStyle(.plain)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(iridescentIndigo, lineWidth: 2.4)
                        )
                    
                    
                    
                    
                    
                    
                    
                }
            }
            .padding()

            // Destination: invisible twin drives the morph; droplet orbits on top
            if showDroplet {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.purple)
                        .opacity(0.0001)                                  // invisible but present
                        .matchedGeometryEffect(id: "buttonBG", in: animNS) // DESTINATION

                    OrbitingDroplet(spinning: $isSpinning)
                        .frame(width: 120, height: 120)                    // square container
                        .allowsHitTesting(false)
                }
                .frame(width: 120, height: 120)
                .zIndex(1)
                .transition(.opacity)
            }
        }
    }
    
    public var iridescentIndigo: LinearGradient { //use in other tab
        LinearGradient(
            colors: [Color.indigo.opacity(0.95), Color.purple.opacity(0.6), Color.indigo.opacity(0.95)],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
    }

    private func start() {
        // 1) Morph button → destination
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            isCollapsing = true
        }

        // 2) Reveal droplet + start orbit
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            showDroplet = true
            isSpinning = true
        }

        // 3) After a lap, jump to Analyzer (rename case if needed)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            appState.selectedTab = .settings
            // reset for next time
            isCollapsing = false
            showDroplet = false
            isSpinning = false
        }
    }
}

// Orbit pieces (no-wobble circular path)

/// Pure translation on a circle; zero wobble.
fileprivate struct CircleOrbitEffect: GeometryEffect {
    var angle: CGFloat       // radians
    var radius: CGFloat

    var animatableData: CGFloat {
        get { angle }
        set { angle = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let x = radius * cos(angle)
        let y = radius * sin(angle)
        return ProjectionTransform(CGAffineTransform(translationX: x, y: y))
    }
}

/// Orbiting droplet that uses the effect above
fileprivate struct OrbitingDroplet: View {
    @Binding var spinning: Bool
    private let radius: CGFloat = 48
    @State private var angle: CGFloat = 0  // radians

    var body: some View {
        ZStack {
            // droplet begins at center; effect moves it along circular path
            Droplet()
                .frame(width: 28, height: 36)
                .modifier(CircleOrbitEffect(angle: angle, radius: radius))
        }
        .frame(width: radius * 2, height: radius * 2) // square container
        .onChange(of: spinning) { on in
            if on {
                withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                    angle = .pi * 2
                }
            } else {
                angle = 0
            }
        }
        .onAppear {
            if spinning {
                withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                    angle = .pi * 2
                }
            }
        }
    }
}

/// Teardrop with gloss + rim light
fileprivate struct Droplet: View {
    var body: some View {
        ZStack {
            DropletShape()
                .fill(
                    LinearGradient(
                        colors: [Color.purple.opacity(0.95), Color.purple.opacity(0.65)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.18), radius: 10, y: 6)

            DropletShape()
                .stroke(Color.white.opacity(0.35), lineWidth: 1.2)
                .blur(radius: 0.4)

            Circle()
                .fill(Color.white.opacity(0.45))
                .frame(width: 10, height: 10)
                .offset(x: -6, y: -8)
                .blur(radius: 0.6)
                .clipShape(DropletShape())
        }
        .compositingGroup()
    }
}

/// Water-droplet outline
fileprivate struct DropletShape: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        // round bottom
        p.addEllipse(in: CGRect(x: 0, y: r.height * 0.25, width: r.width, height: r.height * 0.75))
        // pointed cap
        p.move(to: CGPoint(x: r.midX, y: 0))
        p.addQuadCurve(to: CGPoint(x: r.width * 0.05, y: r.height * 0.35),
                       control: CGPoint(x: r.width * 0.10, y: r.height * 0.02))
        p.addQuadCurve(to: CGPoint(x: r.width * 0.95, y: r.height * 0.35),
                       control: CGPoint(x: r.width * 0.90, y: r.height * 0.02))
        p.addQuadCurve(to: CGPoint(x: r.midX, y: 0),
                       control: CGPoint(x: r.midX, y: r.height * 0.02))
        return p
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())   // provide env object
    }
}
