//
//  WorkoutCardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import SwiftUI

struct CurrentWorkoutCardView: View {
    var title: String
    var subtitle: String
    var content: String
    var options: [IconPillOption]?
    
    init(title: String, subtitle: String, content: String, options: [IconPillOption]? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.content = content
        self.options = options
    }
    
    var body: some View {
        VStack {
            self.topSection
            
            Spacer()
            
            self.bottomSection
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.black)
        .cornerRadius(25)
        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
        .frame(height: 240)
    }
    
    @ViewBuilder
    private var topSection: some View {
        HStack {
            VStack {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white)
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
                Text(content)
                    .font(.caption)
                    .foregroundColor(.white)
                
                if let options = self.options, !options.isEmpty {
                    HStack {
                        ForEach(options, id: \.self) {
                            IconPill(option: $0)
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
        CurrentWorkoutCardView(title: "Back workout",
                               subtitle: "Start your first week",
                               content: "Body contouring",
                               options: [
                                IconPillOption(title: "1x / week", systemImage: "clock"),
                                IconPillOption(title: "Start streak", systemImage: "bolt.badge.clock"),
                                IconPillOption(title: "Complete", systemImage: "bolt.badge.clock")
                               ])
        .previewLayout(.sizeThatFits)
    }
}
