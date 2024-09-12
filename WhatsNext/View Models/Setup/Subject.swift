//
//  Subject.swift
//  WhatsNext
//
//  Created by Tristan Chay on 11/9/24.
//

import SwiftUI

class Subject: ObservableObject {
    static let shared: Subject = .init()
    
    @Published var subjects: [SubjectItem] = [] {
        didSet {
            save()
        }
    }
        
    init() {
        load()
    }
    
    private func getArchiveURL() -> URL {
        let plistName = "subjects.plist"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return documentsDirectory.appendingPathComponent(plistName)
    }
    
    func save() {
        let archiveURL = getArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedTimetableLessons = try? propertyListEncoder.encode(subjects)
        try? encodedTimetableLessons?.write(to: archiveURL, options: .noFileProtection)
    }
    
    func load() {
        let archiveURL = getArchiveURL()
        let propertyListDecoder = PropertyListDecoder()
                
        if let retrievedTimetableLessonData = try? Data(contentsOf: archiveURL),
           let timetableLessonDecoded = try? propertyListDecoder.decode([SubjectItem].self, from: retrievedTimetableLessonData) {
            subjects = timetableLessonDecoded
        }
    }
}
