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
    case hard = 1.0
    case expert = 0.5
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
        NotePosition(note: "E", xPosition: 400, yPosition: 82),
        NotePosition(note: "F", xPosition: 375, yPosition: 82),
        NotePosition(note: "G", xPosition: 335, yPosition: 82),
        NotePosition(note: "A", xPosition: 300, yPosition: 82),
        
        // E STRING
        NotePosition(note: "G", xPosition: 500, yPosition: 72),
        NotePosition(note: "A", xPosition: 450, yPosition: 72),
        NotePosition(note: "B", xPosition: 400, yPosition: 72),
        NotePosition(note: "C", xPosition: 375, yPosition: 72),
        NotePosition(note: "D", xPosition: 335, yPosition: 72),
        NotePosition(note: "C", xPosition: 300, yPosition: 72)
        
    ]
    @Published var score = 0
    var currentNote = ""
    var correct = 0.0
    var total = 0.0
    @Published var currentNoteX: CGFloat = 0
    @Published var currentNoteY: CGFloat = 0
    @Published var counter = 0
    private var timer: Timer?
    
    init() {
        configureQuiz()
    }
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: Difficulty.easy.rawValue, repeats: true) { [weak self] _ in
            self?.displayNote()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        counter = 0
    }
    
    private func timerTick() {
        counter += 1
        
        // Check if you want to stop the timer after a certain number of ticks
        if counter == 10 {
            stopTimer()
        }
    }

   
    func configureQuiz(difficulty: Difficulty = .easy) {
        
    }
    
    func startQuiz() {
        startTimer()
    }
    
    func recordAnswer(note: String) {
        if currentNote == note {
            correct = correct + 1
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
        generator.notificationOccurred(.success)
    }
}


//struct NeckView: View {
//    let numberOfFrets = 21
//    let numberOfStrings = 4
//
//    var body: some View {
//        VStack(spacing: 0) {
//            ForEach(0..<numberOfStrings) { stringIndex in
//                HStack(spacing: 0) {
//                    NeckFretView(fretIndex: 0)
//                        .frame(maxWidth: .infinity)
//                    ForEach(1..<numberOfFrets) { fretIndex in
//                        NeckFretView(fretIndex: fretIndex)
//                            .frame(maxWidth: .infinity)
//                    }
//                    NeckFretView(isLastFret: true)
//                        .frame(maxWidth: .infinity)
//                }
//                .padding(.vertical, 4)
//            }
//        }
//        .padding(.horizontal, 8)
//    }
//}
//
//struct NeckFretView: View {
//    let fretIndex: Int
//    let isLastFret: Bool
//
//    init(fretIndex: Int = 0, isLastFret: Bool = false) {
//        self.fretIndex = fretIndex
//        self.isLastFret = isLastFret
//    }
//
//    var body: some View {
//        VStack(spacing: 0) {
//            Rectangle()
//                .fill(Color.black)
//                .frame(width: 2, height: isLastFret ? 16 : 28)
//
//            if !isLastFret {
//                if [3, 5, 7, 9, 12].contains(fretIndex) {
//                    Circle()
//                        .fill(Color.red)
//                        .frame(width: 8, height: 8)
//                        .padding(.top, 4)
//                } else {
//                    Spacer()
//                        .frame(height: 4)
//                }
//
//                Rectangle()
//                    .fill(Color.gray)
//                    .frame(width: 20, height: 2)
//            }
//        }
//    }
//}


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
                
            //NeckView()
            
            Text("\(quiz.score)")
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
            Button("Start", action: {
                quiz.startQuiz()
            }).padding()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
