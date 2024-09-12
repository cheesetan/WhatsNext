//
//  WelcomeView.swift
//  WhatsNext
//
//  Created by Tristan Chay on 19/7/24.
//

import SwiftUI

struct WelcomeView: View {
    
    @Binding var showingWelcome: Bool
    
    var body: some View {
        VStack {
            Text("Welcome to WhatsNext")
                .font(.title)
                .fontWeight(.heavy)
                .padding(.top, 60)
            
            VStack {
                VStack(spacing: 30) {
                    HStack {
                        Image(systemName: "calendar.day.timeline.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.red, .gray)
                            .symbolRenderingMode(.palette)
                            .padding(.horizontal, 5)
                        
                        VStack(alignment: .leading) {
                            Text("Schedule")
                                .fontWeight(.bold)
                            Text("Schedule your Subjects with ease")
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    HStack {
                        Image(systemName: "clock.badge.checkmark.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.green, .yellow)
                            .symbolRenderingMode(.palette)
                            .padding(.horizontal, 5)
                        
                        VStack(alignment: .leading) {
                            Text("Homework")
                                .fontWeight(.bold)
                            Text("Track your homework submissions and assignments")
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    HStack {
                        Image(systemName: "apps.iphone")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.blue, .gray)
                            .symbolRenderingMode(.palette)
                            .padding(.horizontal, 5)
                        VStack(alignment: .leading) {
                            Text("Widgets")
                                .fontWeight(.bold)
                            Text("View your day's schedule on your home screen.")
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                
                Spacer()
                
                Button {
                    showingWelcome = false
                } label: {
                    Text("Continue")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(.bottom, 30)
            .padding([.horizontal, .top], 40)
        }
    }
}

#Preview {
    WelcomeView(showingWelcome: .constant(true))
}
