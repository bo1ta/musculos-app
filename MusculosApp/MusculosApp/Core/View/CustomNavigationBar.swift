//
//  CustomNavigationBar.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import SwiftUI

struct CustomNavigationBar: View {
    var body: some View {
        HStack {
            RoundedRectangle(cornerSize: CGSize(width: 25, height: 20))
                .frame(maxWidth: .infinity, maxHeight: 60)
                .foregroundColor(.gray)
                .opacity(0.5)
        }
    }
}

struct CustomNavigation_Preview: PreviewProvider {
    static var previews: some View {
        CustomNavigationBar()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
