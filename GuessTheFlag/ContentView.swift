//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by user239371 on 5/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingResults = false
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var totalScore = 0
    @State private var questionCounter = 1
    
    @State private var countries = allCountries.shuffled()
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
       
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.6, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                Spacer()
                Spacer()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
                                .shadow(radius: 20)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 25)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("Score \(totalScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(totalScore)")
        }
        .alert("Game over", isPresented: $showingResults) {
            Button("Start Again", action: restartGame)
        } message: {
            Text("Your final score was \(totalScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            totalScore += 1
        } else {
            let theirAnswer = countries[number]
            
            if theirAnswer == "US" || theirAnswer == "UK" {
                scoreTitle = "Wrong, that's the flag of the \(theirAnswer)"
                
            } else {
                scoreTitle = "Wrong, that's the flag of \(theirAnswer)"
            }
            if totalScore > 0 {
                totalScore -= 1
            }
        }
        if questionCounter == 8 {
            showingResults = true
        } else {
            showingScore = true
        }
    }
    
    
    func askQuestion() {
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionCounter += 1
    }
    
    func restartGame() {
        questionCounter = 0
        totalScore = 0
        countries = Self.allCountries
        askQuestion()
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}

