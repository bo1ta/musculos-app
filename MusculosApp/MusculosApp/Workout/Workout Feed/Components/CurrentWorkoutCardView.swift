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
                    .fontWeight(.bold)
                    .foregroundColor(Color.appColor(with: .spriteGreen))
                Text(exercise.target)
                    .font(.subheadline)
                    .foregroundColor(Color.red)
                Spacer()
            }
            .padding([.top, .leading], 5)
            Spacer()
        }
    }
    
    @ViewBuilder
    private var bottomSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(exercise.equipment)
                    .font(.caption)
                    .foregroundColor(.white)
                
            let options = self.exercise.secondaryMuscles
            if !options.isEmpty {
                    HStack {
                        ForEach(options, id: \.self) {
                            IconPill(option: IconPillOption(title: $0))
                        }
                    }
                }
            }
            .padding([.bottom, .leading], 5)
            Spacer()
        }
    }
}

struct WorkoutCardView_Preview: PreviewProvider {
    static var previews: some View {
        CurrentWorkoutCardView(exercise: Exercise(bodyPart: "back", equipment: "dumbbell", gifUrl: "", id: "1", name: "Back workout", target: "back", secondaryMuscles: [""], instructions: ["Get up", "Get down"]))
        .previewLayout(.sizeThatFits)
    }
}
