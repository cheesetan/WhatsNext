//
//  Recogniser.swift
//  WhatsNext
//
//  Created by Tristan Chay on 11/9/24.
//

import SwiftUI
import Vision
import PhotosUI

class Recogniser: ObservableObject {
    static let shared: Recogniser = .init()
    
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
    
    @Published var image: UIImage?
    @Published var progress: Double = 1.0
    @Published private(set) var extractedLessons: [[ExtractedLesson]] = []
    
    @ObservedObject private var subject: Subject = .shared
    
    func processPhotosPickerItem(item: PhotosPickerItem?) {
        self.extractedLessons = []
        self.setProgress(to: 0)
        Task {
            guard let imageData = try await item?.loadTransferable(type: Data.self) else { self.setProgress(to: 0); return }
            guard let image = UIImage(data: imageData) else { self.setProgress(to: 0); return }
            self.image = image.imageWithOrientationSetToUp()
            self.setProgress(to: 0.2)
            recognizeText(image: image)
        }
    }
    
    private func recognizeText(image: UIImage) {
        var lessons: [ExtractedLesson] = []
        
        guard let cgImage = image.cgImage else { return }
        let request = VNRecognizeTextRequest { (request, error) in
            self.setProgress(to: 0.4)
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                print("Text recognition error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.setProgress(to: 0.6)
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                lessons.append(ExtractedLesson(name: topCandidate.string, position: observation.boundingBox))
            }
            self.setProgress(to: 0.8)
            DispatchQueue.main.async {
                self.subject.load()
                print(self.subject.subjects.map({ $0.name }))
                let validLessons = lessons.filter({ self.subject.subjects.map({ $0.name }).contains($0.name) })
                self.extractedLessons = self.groupByDaysWithDeviations(lessons: validLessons, yTolerance: 0.02)
                self.setProgress(to: 1.0)
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
    
    private func setProgress(to value: Double) {
        if value != 0 {
            withAnimation {
                self.progress = value
            }
        } else {
            self.progress = value
        }
    }
}

