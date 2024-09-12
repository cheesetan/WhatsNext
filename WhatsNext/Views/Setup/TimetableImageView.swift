//
//  TimetableImageView.swift
//  WhatsNext
//
//  Created by Tristan Chay on 12/9/24.
//

import SwiftUI

struct TimetableImageView: View {
    
    @Binding var size: CGSize
    @ObservedObject private var recogniser: Recogniser = .shared
    
    var body: some View {
        Image(uiImage: recogniser.image!)
            .resizable()
            .scaledToFit()
            .overlay {
                ForEach(Array(recogniser.extractedLessons.joined()), id: \.id) { lesson in
                    let boundingBox = lesson.position
                    let width = boundingBox.width * size.width
                    let height = boundingBox.height * size.height
                    let x = boundingBox.minX * size.width
                    let y = (1 - boundingBox.minY) * size.height - height
                    
                    Rectangle()
                        .path(in: CGRect(x: x, y: y, width: width, height: height))
                        .stroke(Color.red, lineWidth: 1)
                }
            }
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .onChange(of: proxy.size) { _ in
                            self.size = proxy.size
                        }
                }
            }
    }
}
