//
//  BassView.swift
//  Bass!
//
//  Created by Derek Bronston on 7/2/23.
//

import SwiftUI

import SwiftUI

struct BassView: View {
    let numberOfFrets = 21
    let numberOfStrings = 4
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Bass Guitar Fretboard")
                .font(.title)
                .padding()
            
            VStack(spacing: 0) {
                ForEach(0..<numberOfStrings) { _ in
                    StringView(fretCount: numberOfFrets)
                        .padding(.vertical, 4)
                }
            }
        }
    }
}

struct StringView: View {
    let fretCount: Int
    
    var body: some View {
        HStack(spacing: 0) {
            FretView(isLastFret: true)
                .frame(width: 32)
            
            ForEach(1..<fretCount) { fretIndex in
                FretView()
            }
        }
    }
}

struct FretView: View {
    let isLastFret: Bool
    
    init(isLastFret: Bool = false) {
        self.isLastFret = isLastFret
    }
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.black)
                .frame(width: 2)
            
            if !isLastFret {
                Spacer()
                    .frame(height: 20)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct BassView_Previews: PreviewProvider {
    static var previews: some View {
        BassView()
    }
}

