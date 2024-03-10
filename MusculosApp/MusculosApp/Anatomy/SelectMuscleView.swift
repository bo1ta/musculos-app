//
//  MusclesSelectorView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 30.09.2023.
//

import SwiftUI

struct SelectMuscleView: View {
  @Environment(\.dismiss) var dismiss

  @State private var frontMusclesIds: [Int]
  @State private var backMusclesIds: [Int]

  @Binding private var selectedMuscles: [MuscleInfo]

  private var muscles: [MuscleName: MuscleInfo] = MuscleData.muscles

  init(selectedMuscles: Binding<[MuscleInfo]> = .constant([])) {
    self._selectedMuscles = selectedMuscles
    self._frontMusclesIds = State(initialValue: [])
    self._backMusclesIds = State(initialValue: [])
    self.maybePopulateAnatomyView()
  }

  private mutating func maybePopulateAnatomyView() {
    guard self.selectedMuscles.count > 0 else { return }

    let mergedFrontMuscleIds = self.selectedMuscles
      .compactMap { $0.imageInfo?.frontAnatomyIds }
      .reduce([], +)
    self._frontMusclesIds = State(initialValue: mergedFrontMuscleIds)

    let mergedBackMuscleIds = self.selectedMuscles
      .compactMap { $0.imageInfo?.backAnatomyIds }
      .reduce([], +)
    self._backMusclesIds = State(initialValue: mergedBackMuscleIds)
  }

  var body: some View {
    backgroundView {
      ScrollView {
        VStack {
          self.anatomyViews
          self.musclePairs
        }
        .padding(.bottom, 50)
      }
    }
  }

  @ViewBuilder
  private var anatomyViews: some View {
    HStack {
      AnatomyOverlayView(musclesIds: self.frontMusclesIds)
      AnatomyOverlayView(musclesIds: self.backMusclesIds, isFront: false)
    }
    .fixedSize()
    .padding([.top, .bottom], 15)
  }

  @ViewBuilder
  private var musclePairs: some View {
    let muscleKeysArray = Array(muscles.keys)
    let musclePairs = muscleKeysArray.chunked(into: 2)

    ForEach(musclePairs, id: \.self) { musclePair in
      HStack(spacing: 3) {
        ForEach(musclePair, id: \.self) { muscleName in
          self.createMuscleCard(with: muscles[muscleName]!)
        }
      }
      .padding(5)
    }
  }

  @ViewBuilder
  private var buttonStack: some View {
    HStack(spacing: 2) {
      Button {
        self.selectedMuscles.removeAll()
        self.frontMusclesIds.removeAll()
        self.backMusclesIds.removeAll()
      } label: {
        Text("Reset")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(DarkButton())
      Button {
        dismiss()
      } label: {
        Text("Continue")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(SelectedButton(isSelected: self.selectedMuscles.count > 0))
    }
  }

  @ViewBuilder
  private func createMuscleCard(with muscle: MuscleInfo) -> some View {
    let isSelected = self.isMuscleSelected(muscle)

    Button(action: {
      self.selectMuscle(muscle)
    }, label: {
      RoundedRectangle(cornerRadius: 10.0)
        .frame(minWidth: 100, minHeight: 100)
        .foregroundStyle(isSelected ? Color.AppColor.green600 : .black)
        .overlay {
          HStack {
            Spacer()
            Text(muscle.name)
              .foregroundStyle(isSelected ? .black : .white)
            Spacer()
          }
        }
    })
  }

  @ViewBuilder
  private func backgroundView(@ViewBuilder content: () -> some View) -> some View {
    ZStack(alignment: .bottom) {
      Image("deadlift-background")
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
        .padding(4)
        .padding(.bottom, 10)
    }
  }

  private func isMuscleSelected(_ muscle: MuscleInfo) -> Bool {
    return self.selectedMuscles.contains(muscle)
  }

  private func selectMuscle(_ muscle: MuscleInfo) {
    if !self.isMuscleSelected(muscle) {
      self.selectedMuscles.append(muscle)

      guard let imageInfo = muscle.imageInfo else { return }

      if let frontAnatomyIds = imageInfo.frontAnatomyIds {
        self.frontMusclesIds.append(contentsOf: frontAnatomyIds)
      }

      if let backAnatomyIds = imageInfo.backAnatomyIds {
        self.backMusclesIds.append(contentsOf: backAnatomyIds)
      }
    } else {
      self.selectedMuscles.removeAll { $0.id == muscle.id }

      guard let imageInfo = muscle.imageInfo else { return }

      if let frontAnatomyIds = imageInfo.frontAnatomyIds {
        let set = Set(frontAnatomyIds)
        self.frontMusclesIds = self.frontMusclesIds
          .filter { !set.contains($0) }
      }
      if let backAnatomyIds = imageInfo.backAnatomyIds {
        let set = Set(backAnatomyIds)
        self.backMusclesIds = self.backMusclesIds
          .filter { !set.contains($0) }
      }
    }
  }
}

#Preview {
  SelectMuscleView()
}
