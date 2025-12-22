import SwiftUI

struct AppConfig: Codable {
    var slideTitle: String
    var imageName: String
    var question: String
    var correctAnswer: String
}

struct ContentView: View {
    @State private var config: AppConfig?
    @State private var userInput: String = ""
    @State private var feedback: String = ""
    @State private var slideNumber: Int = 1

    var body: some View {
        VStack(spacing: 20) {
            if let config = config {
                Text("\(config.slideTitle) (Slide \(slideNumber))")
                    .font(.largeTitle)
                
                Image(systemName: config.imageName) // Uses SF Symbols
                    .resizable()
                    .frame(width: 100, height: 100)
                
                Text(config.question)
                
                TextField("Enter answer here", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Check Answer") {
                    if userInput == config.correctAnswer {
                        feedback = "Correct! Well done."
                    } else {
                        feedback = "Try again!"
                    }
                }

                Text(feedback)
                    .foregroundColor(feedback.contains("Correct") ? .green : .red)

                Button("Next Slide") {
                    nextSlide()
                }
                .disabled(userInput != config.correctAnswer)
            } else {
                Text("Loading today's content...")
                    .onAppear(perform: fetchRemoteConfig)
            }
        }
        .padding()
        .frame(width: 400, height: 500)
    }

    func nextSlide() {
        slideNumber += 1
        userInput = ""
        feedback = ""
        // In a real app, you'd fetch a different JSON or index here
    }

    func fetchRemoteConfig() {
        // REPLACE with your "Raw" GitHub URL
        let url = URL(string: "raw.githubusercontent.com")!
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                let decoded = try? JSONDecoder().decode(AppConfig.self, from: data)
                DispatchQueue.main.async {
                    self.config = decoded
                }
            }
        }.resume()
    }
}
