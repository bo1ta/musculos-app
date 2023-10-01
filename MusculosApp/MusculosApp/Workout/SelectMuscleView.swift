//
//  MusclesSelectorView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 30.09.2023.
//

import SwiftUI

struct SelectMuscleView: View {
    @State var frontMusclesIds: [Int] = []
    @State var backMusclesIds: [Int] = []
    
    @State private var selectedMuscles: [MuscleInfo] = []
    
    private var muscles: [MuscleName: MuscleInfo] = MuscleData.muscles
    
    var body: some View {
        ScrollView {
            VStack {
                self.anatomyViews
                self.musclePairs
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
    private func createMuscleCard(with muscle: MuscleInfo) -> some View {
        let isSelected = self.isMuscleSelected(muscle)
        
        Button(action: {
            self.selectMuscle(muscle)
        }, label: {
            RoundedRectangle(cornerRadius: 10.0)
                .frame(minWidth: 100, minHeight: 100)
                .foregroundStyle(isSelected ? Color.appColor(with: .mustardYellow) : .black)
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
                self.frontMusclesIds = self.frontMusclesIds.filter { !set.contains($0) }
            }
            if let backAnatomyIds = imageInfo.backAnatomyIds {
                let set = Set(backAnatomyIds)
                self.backMusclesIds = self.backMusclesIds.filter { !set.contains($0) }
            }
        }
    }
}

#Preview {
    SelectMuscleView()
}
