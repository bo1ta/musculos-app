//
//  WorkoutFiltersView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.08.2023.
//

import SwiftUI

struct WorkoutFiltersView: View {
    @State private var selectedOption: String = ""
    
    private let genderListItem = SelectListItem(itemTitle: "Gender", options: ["Male", "Female"])
    private let locationListItem = SelectListItem(itemTitle: "Location", options: ["Home", "Gym", "Mix"])
    private let typeListItem = SelectListItem(itemTitle: "Type", options: ["Daily workout", "Workout plan"])
    
    var body: some View {
        backgroundView {
            ScrollView {
                VStack(spacing: 5) {
                    CustomNavigationBarView(onBack: nil, onContinue: nil, title: "Filters", isPresented: true)
                    
                    workoutFilters
                    
                    Spacer()
                }
                .padding([.top])
            }
        }
    }
}

extension WorkoutFiltersView {
    @ViewBuilder
    private var workoutFilters: some View {
        ButtonHorizontalContainerView(selectedOption: $selectedOption, selectListItem: genderListItem)
        ButtonHorizontalContainerView(selectedOption: $selectedOption, selectListItem: locationListItem)
        ButtonHorizontalContainerView(selectedOption: $selectedOption, selectListItem: typeListItem)
        ButtonHorizontalContainerView(selectedOption: $selectedOption, selectListItem: genderListItem)
    }
    
    @ViewBuilder
    private func backgroundView(@ViewBuilder content: () -> some View) -> some View {
        ZStack {
            Image("weightlifting-background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .overlay {
                    Color.black
                        .opacity(0.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                }
            
            content()
                .padding(4)
        }
    }
}

struct WorkoutFiltersView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutFiltersView()
    }
}
