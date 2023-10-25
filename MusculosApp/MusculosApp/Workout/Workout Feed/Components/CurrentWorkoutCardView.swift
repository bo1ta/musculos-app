//
//  WorkoutCardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import SwiftUI

struct CurrentWorkoutCardView: View {
    let exercise: Exercise

    var body: some View {
        VStack {
            self.topSection

            Spacer()

            self.bottomSection
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(self.backgroundView)
        .cornerRadius(25)
        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
        .frame(height: 240)
    }

    @ViewBuilder
    private var backgroundView: some View {
        if let gifUrl = URL(string: self.exercise.gifUrl) {
            GIFView(url: Binding(get: { gifUrl }, set: { _ in }))
        } else {
            Color.black
        }
    }

    @ViewBuilder
    private var topSection: some View {
        HStack {
            VStack {
                Text(exercise.name)
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundStyle(.black)
                Text(exercise.equipment)
                    .font(.title2)
                    .fontWeight(.regular)
                    .foregroundStyle(.black)

                Spacer()
            }
            Spacer()
        }
        .padding([.top, .leading], 5)
    }

    @ViewBuilder
    private var bottomSection: some View {
        HStack {
            let options = self.exercise.secondaryMuscles
            if !options.isEmpty {
                HStack {
                    IconPill(option: IconPillOption(title: self.exercise.target))
                    ForEach(options, id: \.self) {
                        IconPill(option: IconPillOption(title: $0))
                    }
                    Spacer()
                }
            }
        }
        .padding([.bottom, .leading], 5)
        Spacer()
    }
}

struct WorkoutCardView_Preview: PreviewProvider {
    static var previews: some View {
        CurrentWorkoutCardView(exercise: Exercise(bodyPart: "back", equipment: "dumbbell", gifUrl: "", id: "1", name: "Back workout", target: "back", secondaryMuscles: [""], instructions: ["Get up", "Get down"]))
            .previewLayout(.sizeThatFits)
    }
}
