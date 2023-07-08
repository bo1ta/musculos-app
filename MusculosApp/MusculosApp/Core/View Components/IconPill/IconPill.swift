//
//  IconPill.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import SwiftUI

struct IconPill: View {
    private let option: IconPillOption
    
    init(option: IconPillOption) {
        self.option = option
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .foregroundColor(.gray)
            .opacity(0.6)
            .frame(width: 100.0, height: 25)
            .overlay {
                HStack {
                    if let systemImage = self.option.systemImage {
                        Image(systemName: systemImage)
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                    }
                   
                    Text(self.option.title)
                        .foregroundColor(.white)
                        .font(.caption)
                    Spacer()
                }
            }
    }
}

struct IconPill_Preview: PreviewProvider {
    static var previews: some View {
        IconPill(option: IconPillOption(systemImage: "clock", title: "1x / week"))
            .previewLayout(.sizeThatFits)
    }
}
