import CoreML

1func loadModel() -> MyTextClassifier {
2    do {
3        let model = try MyTextClassifier(configuration: MLModelConfiguration())
4        return model
5    } catch {
6        print("Error loading model: \(error)")
7        return nil
8    }
9}
func predict(inputText: String) -> String? {
2    guard let model = loadModel() else { return nil }
3    do {
4        let prediction = try model.prediction(text: inputText)
5        return prediction.label // Adjust based on your model's output
6    } catch {
7        print("Prediction error: \(error)")
8        return nil
9    }
10}
