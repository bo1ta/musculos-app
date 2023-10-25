//
//  WorkoutFiltersView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.08.2023.
//

import SwiftUI

struct WorkoutFiltersView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel: WorkoutFiltersViewModel
    private var onDismiss: ([WorkoutFilterType: String]) -> Void

    init(viewModel: WorkoutFiltersViewModel = WorkoutFiltersViewModel(),
         onDismiss: @escaping ([WorkoutFilterType: String]) -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onDismiss = onDismiss
    }

    var body: some View {
        backgroundView {
            ScrollView {
                VStack(spacing: 8) {
                    CustomNavigationBarView(title: "Filters")

                    workoutFilters

                    SliderView(title: "Workout duration", sliderValue: $viewModel.selectedWorkoutDuration, sliderRange: viewModel.workoutTimeRange)

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
                viewModel.resetState()
            } label: {
                Text("Reset")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(DarkButton())
            Button {
                let selectedFilters: [WorkoutFilterType: String] = [
                    .gender: viewModel.selectedGenderOption,
                    .type: viewModel.selectedTypeOption,
                    .location: viewModel.selectedLocationOption,
                    .body: viewModel.selectedLocationOption,
                    .duration: "\(viewModel.selectedWorkoutDuration)"]
                onDismiss(selectedFilters)
                dismiss()
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
                        .opacity(0.8)
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
        WorkoutFiltersView(onDismiss: { _ in })
    }
}
