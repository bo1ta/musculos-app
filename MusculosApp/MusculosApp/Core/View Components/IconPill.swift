//
//  IconPill.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import SwiftUI

struct IconPill: View {
    private let systemImage: String
    private let title: String
    
    init(systemImage: String, title: String) {
        self.systemImage = systemImage
        self.title = title
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .frame(width: 100.0, height: 25)
            .overlay {
                HStack {
                    Image(systemName: self.systemImage)
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                    Text(self.title)
                        .foregroundColor(.white)
                        .font(.caption)	
                    Spacer()
                }
            }
    }
}

struct IconPill_Preview: PreviewProvider {
    static var previews: some View {
        IconPill(systemImage: "chart.bar.doc.horizontal.fill", title: "1 month")
            .previewLayout(.sizeThatFits)
    }
}
