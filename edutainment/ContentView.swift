//
//  ContentView.swift
//  edutainment
//
//  Created by Subhrajyoti Chakraborty on 10/06/20.
//  Copyright © 2020 Subhrajyoti Chakraborty. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let numbersArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @State private var multiplier = 1
    @State private var multiplicand = 1
    @State private var correctAnswer = 1
    @State private var showStartingView = true
    @State private var usedItems = [Int]()
    @State private var wrongCount = 0
    @State private var rightCount = 0
    @State private var questionCount = 0
    @State private var choices = [Int]()
    @State private var showAlert = false
    
    func startGame() {
        reset()
        questionCount += 1
        showStartingView.toggle()
        calculation()
    }
    
    func nextQuestion() {
        questionCount += 1
        
        if questionCount >= 10 {
            showAlert = true
        } else {
            choices = []
            calculation()
        }
    }
    
    func calculation() {
        multiplicand = getNewMultiplicand()
        usedItems.append(multiplicand)
        correctAnswer = multiplier * multiplicand
        choices.append(correctAnswer)
        getRandomChoices()
    }
    
    func buttonTapped(answer: Int) {
        
        if answer == correctAnswer {
            rightCount += 1
        } else {
            wrongCount += 1
        }
        nextQuestion()
    }
    
    func getNewMultiplicand() -> Int {
        var item = [Int]()
        while item.count < 1 {
            let number = numbersArray.randomElement() ?? 1
            if isAvailable(item: number) {
                item.append(number)
            }
        }
        return item[0]
    }
    
    func isAvailable(item: Int) -> Bool {
        if !usedItems.contains(item) {
            return true
        }
        return false
    }
    
    func getRandomChoices() {
        
        let min = getRange(startPoint: correctAnswer)[0]
        let max = getRange(startPoint: correctAnswer)[1]
        
        print(min, max, correctAnswer)
        
        while choices.count < 4 {
            let choice = Int.random(in: min...max)
            if !choices.contains(choice) {
                choices.append(choice)
            }
        }
    }
    
    func getRange(startPoint: Int) -> [Int] {
        var min = 1
        var max = 10
        
        if startPoint - 3 <= 1 {
            min = 1
        } else {
            min = startPoint - 3
        }
        
        max = startPoint + 3
        
        return [min, max]
    }
    
    func reset() {
        questionCount = 0
        wrongCount = 0
        rightCount = 0
        usedItems = []
        choices = []
    }
    
    var body: some View {
        
        VStack(spacing: 20) {
            if showStartingView {
                Stepper(value: $multiplier, in: 1...10, step: 1) {
                    Text("Multiplication table of  \(multiplier)")
                }
                .font(.largeTitle)
                Button(action: startGame) {
                    Text("Start")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(width: 140, height: 90)
                }
                .padding()
                .frame(width: 160, height: 100)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Text("\(questionCount)/10")
                    .font(.headline)
                
                HStack(spacing: 60) {
                    Text("\(rightCount)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("\(wrongCount)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Text("\(multiplier) X \(multiplicand) = ?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                AnswerGridView(buttonTapped:buttonTapped, choices: choices.shuffled())
            }
            
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Game Over"), message: nil, dismissButton: .default(Text("OK"), action: {
                self.startGame()
            }))
        }
    }
}

struct AnswerGridView: View {
    
    var buttonTapped: (Int) -> Void
    var choices: [Int]
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                AnswerButton(tapped: buttonTapped, number: choices[0])
                Spacer()
                AnswerButton(tapped: buttonTapped, number: choices[1])
            }
            HStack {
                AnswerButton(tapped: buttonTapped, number: choices[2])
                Spacer()
                AnswerButton(tapped: buttonTapped, number: choices[3])
            }
        }
    }
}

struct AnswerButton: View {
    
    var tapped: (Int) -> Void
    var number: Int
    
    var body: some View {
        Button(action: {
            self.tapped(self.number)
        }) {
            Text("\(number)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(width: 140, height: 90)
            
        }
        .padding()
        .frame(width: 160, height: 100)
        .background(Color.purple)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
