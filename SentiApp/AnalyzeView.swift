//
//  AnalyzeView.swift
//  SentiApp
//
//  Created by Chloe Sepulveda on 2025-01-14.
//


import SwiftUI
import CoreML

struct AnalyzeView: View {
    @State private var inputText: String = ""
    @State private var predictionResult: String? = nil
    @State private var isRunning = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {

                // Text input
                TextField("Analyze your text here", text: $inputText, axis: .vertical)
                    .textFieldStyle(.plain)
                    .padding(14)
                    .frame(minHeight: 56, alignment: .topLeading)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(iridescentIndigo, lineWidth: 1.6)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                // Analyze button
                Button(action: runAnalysis) {
                    HStack(spacing: 10) {
                        if isRunning { ProgressView().controlSize(.small) }
                        Text(isRunning ? "Analyzing…" : "Analyze")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
                .buttonStyle(.plain)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(iridescentIndigo, lineWidth: 1.6)
                )
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                // Result card
                if let result = predictionResult {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Result")
                            .font(.headline)
                        Text(result)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .strokeBorder(iridescentIndigo, lineWidth: 1.6)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
            }
            .padding()
        }
        .navigationTitle("Analyze")
        .preferredColorScheme(.light) // stay light mode
    }

    // MARK: - Actions

    private func runAnalysis() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            predictionResult = "Enter some text to analyze."
            return
        }
        isRunning = true
        // If model init is fast  can do this on main; otherwise hop to a background queue.
        DispatchQueue.global(qos: .userInitiated).async {
            let result = makePredictionSync(text: inputText)
            DispatchQueue.main.async {
                self.predictionResult = result
                self.isRunning = false
            }
        }
    }

    /// Synchronous wrapper so we can call it off-main.
    private func makePredictionSync(text: String) -> String {
        guard let model = loadModel() else {
            return "Model loading failed."
        }
        do {
            let input = MyTextClassifierInput(text: text)
            let prediction = try model.prediction(input: input)
            return prediction.label
        } catch {
            return "Error: \(error.localizedDescription)"
        }
    }

    private func loadModel() -> MyTextClassifier? {
        do {
            let model = try MyTextClassifier(configuration: MLModelConfiguration())
            return model
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }

    // - Styling

    public var iridescentIndigo: LinearGradient { //use in other tab
        LinearGradient(
            colors: [Color.indigo.opacity(0.95), Color.purple.opacity(0.6), Color.indigo.opacity(0.95)],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
    }
}

//  Preview

#Preview {
    NavigationStack { AnalyzeView() }
        .preferredColorScheme(.light)
}

    // Adding NLP

