//
//  UserExperienceBar.swift
//  Components
//
//  Created by Solomon Alexandru on 17.12.2024.
//

import SwiftUI

public struct UserExperienceBar: View {
  public var body: some View {
    VStack {
        ZStack {
            // Background
            Color(red: 0.1, green: 0.1, blue: 0.1)
                .ignoresSafeArea()

            VStack {
                // Level Up Indicator
                ZStack {
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 0.2, green: 0.8, blue: 0.2), Color(red: 0.4, green: 0.6, blue: 0.4)]), startPoint: .leading, endPoint: .trailing))
                        .frame(height: 40)
                        .cornerRadius(20)

                    HStack {
                        Text("10")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        ProgressView(value: 65, total: 1278)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 0.2, green: 0.8, blue: 0.2)))
                            .padding(.horizontal)
                        Text("LEVEL UP!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }

                // XP and Gold Display
                HStack {
                    Text("XP +73")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Text("+18 Gold")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                }
                .padding()

                // Character Icon
                Image("character_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            }
            .padding()
        }

        // UI Buttons
        HStack {
            Button(action: {
                // Handle "Back" button action
            }) {
                Text("Back")
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                    )
            }

            Spacer()

            Button(action: {
                // Handle "Next" button action
            }) {
                Text("Next")
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                    )
            }

            Button(action: {
                // Handle "Emote" button action
            }) {
                Image(systemName: "face.smiling")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                    )
            }
        }
        .padding()
    }
  }
}

#Preview {
  UserExperienceBar()
}
