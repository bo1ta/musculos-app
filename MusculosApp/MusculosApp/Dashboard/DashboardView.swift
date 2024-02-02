//
//  DashboardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import SwiftUI

struct DashboardView: View {
  @Environment(\.mainWindowSize) private var mainWindowSize: CGSize
  @State private var selectedSection: CategorySection = .discover
  @State private var searchQuery: String = ""
  
  var body: some View {
    VStack {
      header
      ScrollView {
        ProgressCardView(title: "You've completed 3 muscles", description: "75% of your weekly muscle building goal", progress: 0.75)
          .padding([.leading, .trailing], 10)
          .padding(.top, 20)
        categorySections
        searchAndFilter
        mostPopularSection
        quickWorkoutsSection
      }
    }
    .background(Image("white-patterns-background").resizable(resizingMode: .tile).opacity(0.1))
    .ignoresSafeArea()
//    .frame(width: mainWindowSize.width, height: mainWindowSize.height)
  }
  
  private var header: some View {
    Rectangle()
      .frame(maxWidth: .infinity)
      .frame(height: 130)
      .foregroundStyle(.white)
      .shadow(radius: 10)
      .overlay {
        VStack {
          Spacer()
          HStack {
            Circle()
              .frame(width: 40, height: 40)
              .foregroundStyle(.red)
              .shadow(radius: 1)
            VStack(alignment: .leading) {
              Group {
                Text("Hello,")
                  .font(.custom(AppFont.bold, size: 20))
                  
                Text("Alexandru")
                  .font(.custom(AppFont.regular, size: 15))
              }
              .foregroundStyle(.black)
            }
            Spacer()
            Button {
              print("notification tapped")
            } label: {
              Image(systemName: "bell.fill")
                .foregroundStyle(.black)
                .font(.custom(AppFont.regular, size: 20))
            }
          }
        }
        .padding()
        .padding(.top, 20)
      }
  }
  
  private var mostPopularSection: some View {
    VStack(alignment: .leading) {
      Text("Most popular")
        .font(.custom(AppFont.bold, size: 18))
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 20) {
          CurrentWorkoutCardView(exercise: MockConstants.exercise)
          CurrentWorkoutCardView(exercise: MockConstants.exercise)
          CurrentWorkoutCardView(exercise: MockConstants.exercise)
        }
      }
    }
    .padding()
  }
  
  private var quickWorkoutsSection: some View {
    VStack(alignment: .leading) {
      Text("Quick muscle-building workouts")
        .font(.custom(AppFont.bold, size: 18))
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 20) {
          CurrentWorkoutCardView(exercise: MockConstants.exercise)
          CurrentWorkoutCardView(exercise: MockConstants.exercise)
          CurrentWorkoutCardView(exercise: MockConstants.exercise)
        }
      }
    }
    .padding()
  }
  
  private var categorySections: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 50) {
        createSectionItem(category: .discover)
        createSectionItem(category: .workout)
        createSectionItem(category: .myFavorites)
      }
      .padding()
    }
  }
  
  private var searchAndFilter: some View {
    HStack {
      CustomTextFieldView(text: $searchQuery, textHint: "Search", systemImageName: "magnifyingglass")
        .shadow(radius: 2, y: 1)
      Circle()
        .frame(width: 50, height: 50)
        .foregroundStyle(Color.appColor(with: .customRed))
        .overlay {
          Image(systemName: "line.3.horizontal")
            .foregroundStyle(.white)
        }
        .shadow(radius: 1)
    }
    .padding([.leading, .trailing], 10)
  }
  
  @ViewBuilder
  private func createSectionItem(category: CategorySection) -> some View {
    Button(action: {
      selectedSection = category
    }, label: {
      let isSelected = category == selectedSection
      let widthOfString = category.title.widthOfString(usingFont: UIFont(name: AppFont.medium, size: 18) ?? .boldSystemFont(ofSize: 18))
      
      VStack(spacing: 2) {
        Text(category.title)
          .font(.custom(isSelected ? AppFont.medium : AppFont.light, size: 18))
          .foregroundStyle(.black)
        if isSelected {
          Rectangle()
            .frame(width: widthOfString, height: 2)
            .foregroundStyle(Color.appColor(with: .customRed))
        }
      }
    })
  }
}

#Preview {
  DashboardView()
}

extension DashboardView {
  enum CategorySection: String {
    case discover, workout, myFavorites
    
    var title: String {
      switch self {
      case .discover:
        "Discover"
      case .workout:
        "Workout"
      case .myFavorites:
        "My Favorites"
      }
    }
  }
}