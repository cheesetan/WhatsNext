//
//  TimetableLesson.swift
//  Vision Timetable Reader
//
//  Created by Tristan Chay on 10/9/24.
//

import Foundation

struct TimetableLesson: Identifiable, Codable {
    var id = UUID()
    var name: String
    var date: Date
    var duration: Int
}
