//
//  ExerciseView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 14.08.2023.
//

import SwiftUI
import CoreData

struct ExerciseView: View {
    @Environment(\.dismiss) var dismiss
    let exercise: Exercise
    
    var body: some View {
        VStack(spacing: 10) {
            CustomNavigationBarView(title: self.exercise.name)
                .padding(.bottom, 20)
            
            if let url = URL(string: self.exercise.gifUrl) {
                GIFView(url: Binding(get: { url }, set: { _ in }))
                    .frame(minWidth: 100, minHeight: 100)
                    .padding(7)
                    .padding([.leading, .trailing], 15)
            }
            
            List(self.exercise.instructions, id: \.self) { instruction in
                    Text(instruction)
                    .font(.caption)
            }
            
            Spacer()
        }
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseView(exercise: Exercise(bodyPart: "back", equipment: "dumbbell", gifUrl: "", id: "1", name: "Back workout", target: "back", secondaryMuscles: [""], instructions: ["Get up", "Get down"]))
    }
}
