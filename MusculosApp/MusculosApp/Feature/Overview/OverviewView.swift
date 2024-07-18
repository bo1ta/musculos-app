//
//  OverviewView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.03.2024.
//

import SwiftUI
import Models
import Utility
import Components

struct OverviewView: View {
  @Environment(\.userStore) private var userStore
  @Environment(\.healthKitViewModel) private var healthKitViewModel
  
  var body: some View {
    ScrollView {
      VStack(spacing: 10) {
        HStack {
          Spacer()
          
          Text(userStore.displayName)
            .font(AppFont.body(.bold, size: 16.0))
          avatarCircle
        }
        .padding(.trailing, 15)
        
        overviewSection
          .padding(.top, 15)
        highlightsSection
          .padding(.top, 15)
        reportSection
          .padding(.top, 15)
        
        WhiteBackgroundCard()
      }
      .padding(.horizontal, 15)
    }
    .task {
      if healthKitViewModel.isAuthorized {
        await healthKitViewModel.loadAllData()
      } else {
        // load different data
      }
    }
    .scrollIndicators(.hidden)
  }
}

// MARK: - Private views

extension OverviewView {
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
          Text(DateHelper.currentDayDisplay())
            .foregroundStyle(.gray)
            .font(.body(.semiBold, size: 15))
        }
        .shadow(radius: 0.2)
        .padding(.bottom, 10)
  
        Text("Overview")
          .font(.header(.bold, size: 23))
          .shadow(radius: 0.5)
  
        ScoreCard(title: "Health Score",
                  description: "Based on your overview health tracking, your score is 87 and considered good",
                  score: 87,
                  onTap: {},
                  color: Color.AppColor.blue100)
      }
      Spacer()
    }
  }
  
  private var highlightsSection: some View {
    VStack(alignment: .leading) {
      Text("Highlights")
        .font(.header(.bold, size: 23))
        .shadow(radius: 0.5)
      
      HStack(spacing: 15) {
        HighlightCard(title: "Steps",
                      value: healthKitViewModel.stepsCount,
                      description: "updated 15 min ago",
                      imageName: "figure.run",
                      color: Color.AppColor.blue700
        )
        HighlightCard(title: "Sleep",
                      value: "7h 31 min",
                      description: "updated a day ago",
                      imageName: "sleep",
                      color: Color.AppColor.darkPurple)
      }
      HStack(spacing: 15) {
        HighlightCard(title: "Water",
                      value: healthKitViewModel.dietaryWater,
                      description: "updated 5 min ago",
                      imageName: "drop.fill",
                      color: Color.AppColor.blue500)
        HighlightCard(title: "Workout",
                      value: "1 day",
                      description: "updated a day ago",
                      imageName: "dumbbell.fill",
                      color: Color.AppColor.green700)
      }
    }
  }
  
  private var reportSection: some View {
    VStack(alignment: .leading) {
      Text("This week report")
        .font(.header(.bold, size: 23))
        .shadow(radius: 0.5)
      
      HStack(spacing: 15) {
        makeStatReportCard(.steps)
        makeStatReportCard(.workout)
      }
      HStack(spacing: 15) {
        makeStatReportCard(.water)
        makeStatReportCard(.sleep)
      }
    }
  }
}

// MARK: - Helper methods

extension OverviewView {
  private func makeStatReportCard(_ statType: OverviewStatType) -> some View {
    StatReportCard(emojiIcon: statType.emojiIcon, title: statType.title, value: statType.value)
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

// MARK: - Constants

extension OverviewView {
  private enum OverviewStatType: String {
    case steps, workout, water, sleep
    
    var title: String {
      return rawValue.capitalized
    }
    
    var emojiIcon: String {
      switch self {
      case .steps:
        "👣"
      case .workout:
        "💪"
      case .water:
        "💧"
      case .sleep:
        "😴"
      }
    }
    
    // hardcoded for now
    var value: String {
      switch self {
      case .steps:
        "697,978"
      case .workout:
        "6h 45min"
      case .water:
        "10,659 ml"
      case .sleep:
        "29h 17min"
      }
    }
  }
}

#Preview {
  OverviewView()
}
