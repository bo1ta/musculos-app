//
//  IconButton.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import SwiftUI

struct IconButton: View {
    let systemImage: String
    let action: () -> Void
    
    init(systemImage: String, action: @escaping () -> Void = {}) {
        self.systemImage = systemImage
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .padding(16)
                .background(Color.gray)
                .clipShape(Circle())
        }
    }
}

struct IconButton_Preview: PreviewProvider {
    static var previews: some View {
        IconButton(systemImage: "person")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
