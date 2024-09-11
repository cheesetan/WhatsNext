//
//  Recogniser.swift
//  WhatsNext
//
//  Created by Tristan Chay on 11/9/24.
//

import SwiftUI
import Vision
import Observation

@Observable
class Recogniser {
    
    private var lessonsAttending: [String] = [
        "CL",
        "BREAK",
        "INT MATH",
        "EL",
        "SS",
        "CH(GE)",
        "COMP",
        "PHY",
        "S&W",
        "ELEC",
        "CCE",
        "ADV/ASSB"
    ]
    
    private(set) var extractedLessons: [ExtractedLesson] = []
    
    func recognizeText(image: UIImage) {
        var lessons: [ExtractedLesson] = []
        
        guard let cgImage = image.cgImage else { return }
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                print("Text recognition error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                lessons.append(ExtractedLesson(name: topCandidate.string, position: observation.boundingBox))
            }
            DispatchQueue.main.async {
                let validLessons = lessons.filter({ self.lessonsAttending.contains($0.name) })
                self.extractedLessons = validLessons
                print(self.groupByDaysWithDeviations(lessons: validLessons, yTolerance: 0.02).map({ $0.map({ $0.name }) }))
            }
        }
        request.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(cgImage: cgImage)
        try? handler.perform([request])
    }

    private func groupByDaysWithDeviations(lessons: [ExtractedLesson], yTolerance: CGFloat) -> [[ExtractedLesson]] {
        var result: [[ExtractedLesson]] = []
        
        let roughSortLessons = lessons.sorted { $0.position.origin.y > $1.position.origin.y }
        
        var currentGroup: [ExtractedLesson] = []
        
        for lesson in roughSortLessons {
            let yPosition = lesson.position.origin.y
            
            if currentGroup.last != nil {
                let groupAverageY = averageY(for: currentGroup)
                
                if abs(yPosition - groupAverageY) > yTolerance {
                    currentGroup.sort { $0.position.origin.x < $1.position.origin.x }
                    result.append(currentGroup)
                    currentGroup = []
                }
            }
            
            currentGroup.append(lesson)
        }
        
        if !currentGroup.isEmpty {
            currentGroup.sort { $0.position.origin.x < $1.position.origin.x }
            result.append(currentGroup)
        }
        
        return result
    }
    
    private func averageY(for group: [ExtractedLesson]) -> CGFloat {
        return group.map { $0.position.origin.y }.reduce(0, +) / CGFloat(group.count)
    }
}

