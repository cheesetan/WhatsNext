//
//  SetupView.swift
//  WhatsNext
//
//  Created by Tristan Chay on 11/9/24.
//

import SwiftUI

struct SetupView: View {
    
    @State private var recogniser = Recogniser()
    
    var body: some View {
        GeometryReader { geometry in
            Image("timetable")
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .overlay(
                    ForEach(recogniser.extractedLessons, id: \.id) { lesson in
                        let boundingBox = lesson.position
                        let width = boundingBox.width * geometry.size.width
                        let height = boundingBox.height * geometry.size.height
                        let x = boundingBox.minX * geometry.size.width
                        let y = (1 - boundingBox.minY) * geometry.size.height - height
                        
                        Rectangle()
                            .path(in: CGRect(x: x, y: y, width: width, height: height))
                            .stroke(Color.red, lineWidth: 2)
                    }
                )
        }
        .onAppear {
            recogniser.recognizeText(image: UIImage(named: "timetable")!)
        }
    }
}

#Preview {
    SetupView()
}
