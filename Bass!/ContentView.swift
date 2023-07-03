//
//  ContentView.swift
//  Bass!
//
//  Created by Derek Bronston on 7/1/23.
//

import SwiftUI
import Foundation

/**
 
 Show neck
 randomly put red dot on note
 play note simulatneously
 take input for note, on timer 3 seconds.
 make time variation: easy, medium, hard
    - easy 10 seconds
 `  - medium 5 seconds
    - hard 2 seconds
    - expert .5 seconds
 keep score
 display score
 
 */

enum Difficulty: Double {
    typealias RawValue = Double
    
    case easy = 3.0
    case medium = 2.0
    case hard = 1.5
    case expert = 0.75
}

struct NotePosition {
    let note: String
    let xPosition: CGFloat
    let yPosition: CGFloat
}

class Quiz: ObservableObject {
    let notes = [
        // A STRING
        NotePosition(note: "C", xPosition: 500, yPosition: 82),
        NotePosition(note: "D", xPosition: 450, yPosition: 82),
        NotePosition(note: "E", xPosition: 402, yPosition: 80),
        NotePosition(note: "F", xPosition: 375, yPosition: 80),
        NotePosition(note: "G", xPosition: 335, yPosition: 80),
        NotePosition(note: "A", xPosition: 300, yPosition: 80),
        
        // E STRING
        NotePosition(note: "F", xPosition: 555, yPosition: 72),
        NotePosition(note: "G", xPosition: 500, yPosition: 70),
        NotePosition(note: "A", xPosition: 448, yPosition: 70),
        NotePosition(note: "B", xPosition: 400, yPosition: 70),
        NotePosition(note: "C", xPosition: 375, yPosition: 70),
        NotePosition(note: "D", xPosition: 335, yPosition: 69),
        NotePosition(note: "E", xPosition: 300, yPosition: 69)
        
    ]
    @Published var score = 0
    var currentNote = ""
    var correct = 0.0
    var total = 0.0
    @Published var currentDifficulty = Difficulty.easy
    @Published var currentNoteX: CGFloat = 0
    @Published var currentNoteY: CGFloat = 0
    
    @Published var counter = 0
    @Published var ctaLabel: String = "Start"
    private var timer: Timer?
    
    init() {
        configureQuiz()
    }
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: currentDifficulty.rawValue, repeats: true) { [weak self] _ in
            self?.displayNote()
        }
    }
    
    func stopTimer() {
        ctaLabel = "Start"
        timer?.invalidate()
        timer = nil
        counter = 0
    }
    
   
    func configureQuiz(difficulty: Difficulty = .easy) {
        currentDifficulty = difficulty
        stopTimer()
        ctaLabel = "Start"
        
    }
    
    func startQuiz() {
        if ctaLabel == "Stop" {
            stopTimer()
        } else {
            startTimer()
            ctaLabel = "Stop"
        }
    }
    
    func recordAnswer(note: String) {
        if currentNote == note {
            correct = correct + 1
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } else {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
        total = total + 1
        let percentageAsDouble = ((correct / total) * 100)
        score = Int(percentageAsDouble)
    }
    
    func displayNote(){
        let randomInt = Int.random(in: 0...(notes.count - 1))
        currentNote = notes[randomInt].note
        currentNoteX = notes[randomInt].xPosition
        currentNoteY = notes[randomInt].yPosition
        vibrate()
        
    }
    
    func displayScore() {
        
    }
    
    func vibrate() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
}


struct ContentView: View {
    @StateObject private var quiz = Quiz()
    var body: some View {
        VStack {
            
            ZStack {
                Image("Bass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 900)
                    .zIndex(99)
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 10)
                    .position(x: quiz.currentNoteX, y: quiz.currentNoteY)
                    .zIndex(100)
            }
            
            HStack {
                Button("Easy", action: {
                    quiz.configureQuiz(difficulty: .easy)
                })
                .foregroundColor((quiz.currentDifficulty == .easy ? .red : .blue))
                
                Button("Medium", action: {
                    quiz.configureQuiz(difficulty: .medium)
                })
                .foregroundColor((quiz.currentDifficulty == .medium ? .red : .blue))
                
                Button("Hard", action: {
                    quiz.configureQuiz(difficulty: .hard)
                })
                .foregroundColor((quiz.currentDifficulty == .hard ? .red : .blue))
                
                Button("Expert", action: {
                    quiz.configureQuiz(difficulty: .expert)
                })
                .foregroundColor((quiz.currentDifficulty == .expert ? .red : .blue))
            }
            HStack {
                Button("C", action: {
                    quiz.recordAnswer(note: "C")
                })
                .padding()
                
                Button("D", action: {
                    quiz.recordAnswer(note: "D")
                })
                .padding()
                Button("E", action: {
                    quiz.recordAnswer(note: "E")
                }).padding()
                
                Button("F", action: {
                    quiz.recordAnswer(note: "F")
                }).padding()
                
                
                Button("G", action: {
                    quiz.recordAnswer(note: "G")
                }).padding()
                
                Button("A", action: {
                    quiz.recordAnswer(note: "A")
                }).padding()
                
                Button("B", action: {
                    quiz.recordAnswer(note: "B")
                }).padding()
            }
            HStack {
                Button(quiz.ctaLabel, action: {
                    quiz.startQuiz()
                }).padding()
                               
                
            }.padding()
            

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
