//
//  ExtractedLesson.swift
//  Vision Timetable Reader
//
//  Created by Tristan Chay on 10/9/24.
//

import SwiftUI

struct ExtractedLesson: Identifiable {
    let id = UUID()
    var name: String
    var position: CGRect
}
