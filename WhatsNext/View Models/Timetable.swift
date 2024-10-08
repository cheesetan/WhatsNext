//
//  Timetable.swift
//  WhatsNext
//
//  Created by Tristan Chay on 11/9/24.
//

import SwiftUI
import PhotosUI

class Timetable: ObservableObject {
    static let shared: Timetable = .init()
    
    @Published var subjects: [[TimetableLesson]] = [] {
        didSet {
            save()
        }
    }
        
    init() {
        load()
    }
    
    private func getArchiveURL() -> URL {
        let plistName = "timetable.plist"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return documentsDirectory.appendingPathComponent(plistName)
    }
    
    private func save() {
        let archiveURL = getArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedTimetableLessons = try? propertyListEncoder.encode(subjects)
        try? encodedTimetableLessons?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func load() {
        let archiveURL = getArchiveURL()
        let propertyListDecoder = PropertyListDecoder()
                
        if let retrievedTimetableLessonData = try? Data(contentsOf: archiveURL),
           let timetableLessonDecoded = try? propertyListDecoder.decode([[TimetableLesson]].self, from: retrievedTimetableLessonData) {
            subjects = timetableLessonDecoded
        }
    }
}
