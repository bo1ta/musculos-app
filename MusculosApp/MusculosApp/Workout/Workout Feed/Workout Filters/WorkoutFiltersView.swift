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
                VStack(spacing: 8) {
                    CustomNavigationBarView(onBack: nil, onContinue: nil, title: "Filters", isPresented: true)
                    
                    workoutFilters
                    
                    SliderView(title: "Workout duration", sliderValue: $viewModel.workoutDuration)
                    
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    private var workoutFilters: some View {
        ButtonHorizontalContainerView(selectedOption: $viewModel.selectedGenderOption, selectListItem: viewModel.genderListItem)
        ButtonHorizontalContainerView(selectedOption: $viewModel.selectedTypeOption, selectListItem: viewModel.typeListItem)
        ButtonHorizontalContainerView(selectedOption: $viewModel.selectedLocationOption, selectListItem: viewModel.locationListItem)
        ButtonHorizontalContainerView(selectedOption: $viewModel.selectedBodyOption, selectListItem: viewModel.bodyListItem)
    }
    
    @ViewBuilder
    private var buttonStack: some View {
        HStack(spacing: 2) {
            Button {
                print("")
            } label: {
                Text("Reset")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(DarkButton())
            Button {
                print("")
            } label: {
                Text("Apply")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryButton())
        }
    }
}

extension WorkoutFiltersView {
    @ViewBuilder
    private func backgroundView(@ViewBuilder content: () -> some View) -> some View {
        ZStack(alignment: .bottom) {
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
            
            buttonStack
        }
    }
}

struct WorkoutFiltersView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutFiltersView()
    }
}
