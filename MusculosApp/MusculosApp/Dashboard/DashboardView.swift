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
  
  @State private var selectedSection: CategorySection = .discover
  @State private var searchQuery: String = ""
  
  @State private var showFilterView: Bool = false
  @State private var showExerciseDetails: Bool = false
  @State private var selectedExercise: Exercise? = nil
  
  @StateObject private var debouncedQueryObserver = DebouncedQueryObserver()
  
  var body: some View {
    NavigationStack {
      VStack {
        header
        ScrollView(showsIndicators: false) {
          ProgressCardView(title: "You've completed 3 exercises", description: "75% of your weekly muscle building goal", progress: 0.75)
            .padding([.leading, .trailing], 10)
            .padding(.top, 20)
          categoryTabs
          searchAndFilter
          
          createWorkoutCardSection(title: "Most popular", exercises: exerciseStore.results)
          createWorkoutCardSection(title: "Quick muscle-building workouts", exercises: exerciseStore.results, isSmallCard: true)
        }
      }
      .onChange(of: debouncedQueryObserver.debouncedQuery) { query in
        exerciseStore.searchFor(query: query)
      }
      .onAppear {
        userStore.fetchUserProfile()
        exerciseStore.loadExercises()
      }
      .onDisappear {
        exerciseStore.cleanUp()
      }
      .popover(isPresented: $showFilterView) {
        SearchFilterView()
      }
      .background(backgroundImage)
      .overlay {
        if userStore.isLoading || exerciseStore.isLoading {
          LoadingOverlayView()
        }
      }
      .navigationDestination(isPresented: $showExerciseDetails) {
        if let selectedExercise {
          ExerciseDetailsView(exercise: selectedExercise)
        }
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
  
  private var searchAndFilter: some View {
    HStack {
      RoundedTextField(text: $debouncedQueryObserver.searchQuery, textHint: "Search", systemImageName: "magnifyingglass")
        .shadow(radius: 2, y: 1)
      Button(action: {
        showFilterView = true
      }, label: {
        Circle()
          .frame(width: 50, height: 50)
          .foregroundStyle(Color.appColor(with: .customRed))
          .overlay {
            Image(systemName: "line.3.horizontal")
              .foregroundStyle(.white)
          }
          .shadow(radius: 1)
      })
    }
    .padding([.leading, .trailing], 10)
  }
}

// MARK: - Helper methods

extension DashboardView {
  private func createWorkoutCardSection(title: String,
                                        exercises: [Exercise],
                                        isSmallCard: Bool = false) -> some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.custom(AppFont.bold, size: 18))
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 20) {
          ForEach(exercises, id: \.id) { exercise in
            Button(action: {
              selectedExercise = exercise
              showExerciseDetails = true
            }, label: {
              CurrentWorkoutCardView(exercise: exercise, cardWidth: isSmallCard ? 200 : 300)
            })
          }
        }
      }
    }
    .padding()
  }
  
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
  DashboardView().environmentObject(UserStore()).environmentObject(ExerciseStore())
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
