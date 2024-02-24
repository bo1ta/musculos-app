//
//  DashboardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import SwiftUI

struct DashboardView: View {
  @EnvironmentObject private var userStore: UserStore
  @EnvironmentObject private var exerciseStore: ExerciseStore
  @EnvironmentObject private var tabBarSettings: TabBarSettings
  
  @State private var selectedSection: CategorySection = .discover
  @State private var searchQuery: String = ""
  @State private var showFilterView: Bool = false
  @State private var showExerciseDetails: Bool = false
    
  @State private var selectedExercise: Exercise? = nil {
    didSet {
      if selectedExercise != nil {
        showExerciseDetails = true
      }
    }
  }

  var body: some View {
    NavigationStack {
      VStack {
        header
        ScrollView(showsIndicators: false) {
          ProgressCardView(title: "You've completed 3 exercises", description: "75% of your weekly muscle building goal", progress: 0.75)
            .padding([.leading, .trailing], 10)
            .padding(.top, 20)
          categoryTabs
          
          SearchFilterFieldView(showFilterView: $showFilterView, hasObservedQuery: { query in
            exerciseStore.searchByMuscleQuery(query)
          })
          
          switch exerciseStore.state {
          case .loading:
           DashboardLoadingView()
            .task {
              await userStore.fetchUserProfile()
              exerciseStore.loadLocalExercises()
            }
          case .loaded(let exercises):
            ExerciseCardSection(title: "Most popular", exercises: exercises, onExerciseTap: {
              exercise in
              selectedExercise = exercise
            })
            ExerciseCardSection(title: "Quick muscle-building workouts", exercises: exercises, isSmallCard: true, onExerciseTap: {
              exercise in
              selectedExercise = exercise
            })
          case .empty(_):
            Text("No data found!")
          case .error(_):
            EmptyView()
          }
        }
      }
      .popover(isPresented: $showFilterView) {
        SearchFilterView()
      }
      .background(backgroundImage)
      .navigationDestination(isPresented: $showExerciseDetails) {
        if let exercise = selectedExercise {
          ExerciseDetailsView(exercise: exercise)
        }
      }
      .onAppear {
        DispatchQueue.main.async {
          tabBarSettings.isTabBarHidden = false
        }
      }
      .onDisappear {
        exerciseStore.cleanUp()
      }
      .ignoresSafeArea()
    }
  }
  
  // MARK: - Views
  
  private var backgroundImage: some View {
    Image("white-patterns-background")
      .resizable(resizingMode: .tile)
      .opacity(0.1)
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
                Text(userStore.displayName)
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
  
  private var categoryTabs: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 50) {
        ForEach(CategorySection.allCases, id: \.title) { categorySection in
          createSectionItem(category: categorySection)
        }
      }
      .padding()
    }
  }
}

// MARK: - Helper methods

extension DashboardView {
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
  DashboardView().environmentObject(UserStore()).environmentObject(ExerciseStore()).environmentObject(TabBarSettings(isTabBarHidden: false))
}

extension DashboardView {
  enum CategorySection: String, CaseIterable {
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
