//
//  CustomNavigationBar.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import SwiftUI

struct CustomNavigationBar: View {
    private let leftButton: IconButton
    private let rightButton: IconButton
    
    init(leftButton: IconButton, rightButton: IconButton) {
        self.leftButton = leftButton
        self.rightButton = rightButton
    }
    
    var body: some View {
        HStack {
            self.leftButton
            Spacer()
            self.rightButton
        }
        .padding()
        .background(Capsule().fill(.gray))
    }
}

struct CustomNavigation_Preview: PreviewProvider {
    static var previews: some View {
        CustomNavigationBar(leftButton: IconButton(systemImage: "arrowshape.backward.fill"), rightButton: IconButton(systemImage: "figure.skating"))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
