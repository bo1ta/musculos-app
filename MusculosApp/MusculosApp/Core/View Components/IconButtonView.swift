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
    
    init(systemImage: String, action: @escaping () -> Void = {}) {
        self.systemImage = systemImage
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 25))
                .foregroundColor(.black)
                .padding(15)
                .background(Color.appColor(with: .background))
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
