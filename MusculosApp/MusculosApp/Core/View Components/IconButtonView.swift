//
//  IconButtonView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import SwiftUI

struct IconButtonView: View {
    let systemImage: String
    let action: () -> Void
    let backgroundColor: Color

    init(systemImage: String, backgroundColor: Color = Color.appColor(with: .background), action: @escaping () -> Void = {}) {
        self.systemImage = systemImage
        self.backgroundColor = backgroundColor
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 18))
                .foregroundColor(.gray)
                .padding(15)
                .background(self.backgroundColor)
                .clipShape(Circle())
        }
    }
}

struct IconButtonView_Preview: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color
                .gray
                .frame(width: 100, height: 100)
            IconButtonView(systemImage: "person")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
