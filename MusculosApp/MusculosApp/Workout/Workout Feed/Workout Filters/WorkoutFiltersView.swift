//
//  WorkoutFiltersView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.08.2023.
//

import SwiftUI

struct WorkoutFiltersView: View {
    @ObservedObject private var viewModel: WorkoutFiltersViewModel
    
    init(viewModel: WorkoutFiltersViewModel = WorkoutFiltersViewModel()) {
        self.viewModel = viewModel
    }
    
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
    
    @ViewBuilder
    private var workoutFilters: some View {
        ButtonHorizontalContainerView(selectedOption: $viewModel.selectedGenderOption, selectListItem: viewModel.genderListItem)
        ButtonHorizontalContainerView(selectedOption: $viewModel.selectedTypeOption, selectListItem: viewModel.typeListItem)
        ButtonHorizontalContainerView(selectedOption: $viewModel.selectedLocationOption, selectListItem: viewModel.locationListItem)
    }
}

extension WorkoutFiltersView {
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
