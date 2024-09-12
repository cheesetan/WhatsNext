//
//  ImageUploadView.swift
//  WhatsNext
//
//  Created by Tristan Chay on 11/9/24.
//

import SwiftUI
import PhotosUI

struct TimetableInformationView: View {
    
    @State private var size: CGSize = CGSize()
    @State private var imageFromPhotos: PhotosPickerItem?
    
    @State private var showingPhotosPicker = false
    
    @ObservedObject private var recogniser: Recogniser = .shared
    @StateObject private var subject = Subject()
    
//    @EnvironmentObject private var timetable: Timetable
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach($subject.subjects, id: \.id) { $subject in
                        TextField("Subject Name", text: $subject.name)
                    }
                    .onDelete { indexSet in
                        withAnimation {
                            subject.subjects.remove(atOffsets: indexSet)
                        }
                    }
                    
                    Button("Add new Subject") {
                        withAnimation {
                            subject.subjects.append(SubjectItem(name: ""))
                        }
                    }
                } header: {
                    Text("Subject Names (as per timetable)")
                }
                
                Section {
                    
                } header: {
                    Text("Subject Timings (in minutes)")
                }
                
                Section {
                    Menu {
                        Button {
                            
                        } label: {
                            Label("Scan with Camera", systemImage: "camera")
                        }
                        Button {
                            showingPhotosPicker.toggle()
                        } label: {
                            Label("Select from Photos", systemImage: "photo.on.rectangle.angled")
                        }
                    } label: {
                        if recogniser.image != nil {
                            TimetableImageView(size: $size)
                                .environmentObject(recogniser)
                        } else {
                            Text("Upload Timetable")
                        }
                    }
                    if recogniser.image != nil {
                        Button("Refresh Analysis") {
                            recogniser.processPhotosPickerItem(item: imageFromPhotos)
                        }
                    }
                } header: {
                    Text("Timetable")
                }
                
                Section {
                    Button {
                        
                    } label: {
                        if recogniser.progress != 1.0 {
                            ProgressView(value: recogniser.progress, total: 1)
                                .progressViewStyle(.linear)
                        } else {
                            Text("Continue")
                        }
                    }
                    .disabled(recogniser.image == nil || recogniser.extractedLessons.isEmpty || recogniser.progress != 1.0)
                }
            }
            .navigationTitle("Timetable Information")
        }
        .scrollDismissesKeyboard(.interactively)
        .photosPicker(isPresented: $showingPhotosPicker, selection: $imageFromPhotos)
        .onChange(of: imageFromPhotos) { _ in
            recogniser.processPhotosPickerItem(item: imageFromPhotos)
        }
    }
}

#Preview {
    TimetableInformationView()
}
