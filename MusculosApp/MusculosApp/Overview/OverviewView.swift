//
//  OverviewView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.03.2024.
//

import SwiftUI

struct OverviewView: View {
  @EnvironmentObject private var userStore: UserStore
  
  var body: some View {
    ScrollView {
      VStack(spacing: 10) {
        HStack {
          Spacer()
          avatarCircle
        }
        .padding(.trailing, 15)
        
        overviewSection
        highlightsSection
        reportSection
        
        WhiteBackgroundCard()
      }
      .padding([.leading, .trailing], 15)
    }
    .scrollIndicators(.hidden)
  }
  
  private var avatarCircle: some View {
    Circle()
      .frame(width: 60, height: 60)
      .foregroundStyle(.blue)
      .shadow(radius: 1.2)
  }
  
  private var overviewSection: some View {
    HStack {
      VStack(alignment: .leading) {
        HStack {
          Image(systemName: "sun.min")
            .foregroundStyle(.gray)
            .font(.header(.bold, size: 25))
          Text("TUES 11 JUL")
            .foregroundStyle(.gray)
            .font(.body(.semiBold, size: 15))
        }
        .shadow(radius: 0.2)
        .padding(.bottom, 1)
        makeTitleSection("Overview", withButton: "All data", onButtonTap: {})
        ScoreCard(title: "Health Score", description: "Based on your overview health tracking, your score is 87 and considered good", score: 87, onTap: {
        }, color: AppColor.lightCyan.color, badgeColor: .purple)
      }
      Spacer()
    }
  }
  
  private var highlightsSection: some View {
    VStack {
      makeTitleSection("Highlights", withButton: "View more", onButtonTap: {
        print("view more")
      })
      
      HStack(spacing: 15) {
        HighlightCard(title: "Steps", value: "11,857", description: "updated 15 min ago", imageName: "figure.run")
        HighlightCard(title: "Sleep", value: "7h 31 min", description: "updated a day ago", imageName: "sleep", color: .blue)
      }
      HStack(spacing: 15) {
        HighlightCard(title: "Nutrition", value: "960 kcal", description: "updated 5 min ago", imageName: "carrot.fill", color: .orange)
        HighlightCard(title: "Workout tracking", value: "1 day since last workout", description: "updated a day ago", imageName: "dumbbell.fill", color: .green)
      }
    }
  }
  
  private var reportSection: some View {
    VStack {
      makeTitleSection("This week report", withButton: "View more", onButtonTap: {})
      
      HStack(spacing: 15) {
        StatReportCard(emojiIcon: "👣", title: "Steps", value: "697,978")
        StatReportCard(emojiIcon: "💪", title: "Workout", value: "6h 45min")
      }
      HStack(spacing: 15) {
        StatReportCard(emojiIcon: "💧", title: "Water", value: "10,659 ml")
        StatReportCard(emojiIcon: "😴", title: "Sleep", value: "29h 17min")
      }
    }
  }
  
  private func makeTitleSection(_ title: String, withButton buttonText: String? = nil, onButtonTap: (() -> Void)? = nil) -> some View {
    HStack {
      Text(title)
        .font(.header(.bold, size: 23))
        .shadow(radius: 0.5)
      Spacer()
      if let buttonText, let onButtonTap {
        Button(action: onButtonTap, label: {
          Text(buttonText)
            .font(.body(.semiBold, size: 15))
            .shadow(radius: 0.2)
            .foregroundStyle(.gray)
        })
      }
    }
    .padding(.trailing, 10)
  }
}

#Preview {
  OverviewView().environmentObject(UserStore())
}
