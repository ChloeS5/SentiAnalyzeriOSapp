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
    @State private var predictionResult: String = ""

    var body: some View {
        VStack {
            TextField("Analyze your text here", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Submit") {
                self.makePrediction()
            }
            .padding()

            Text("Prediction: \(predictionResult)")
                .padding()
        }
        .padding()
    }

    private func makePrediction() {
        
        guard let model = loadModel() else {
            predictionResult = "Model loading failed."
            return
        }
        
        do {
            
            let input = MyTextClassifierInput(text: inputText)
            let prediction = try model.prediction(input: input)
            predictionResult = prediction.label //
        } catch {
            predictionResult = "Error: \(error.localizedDescription)"
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
}

#Preview {
    ContentView()
}

    
    // Adding NLP

