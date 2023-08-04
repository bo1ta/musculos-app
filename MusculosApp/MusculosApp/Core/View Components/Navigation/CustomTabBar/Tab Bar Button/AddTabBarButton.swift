//
//  AddTabBarButton.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.08.2023.
//

import Foundation
import SwiftUI

struct AddTabBarButton: CustomTabBarButton {
    var onTapGesture: () -> Void
    var tabBarItem: TabBarItem { .add }
    
    init(onTapGesture: @escaping () -> Void) {
        self.onTapGesture = onTapGesture
    }
    
    var body: some View {
        Circle()
            .foregroundStyle(Color(.white))
            .overlay {
                Circle()
                    .foregroundStyle(.black)
                    .overlay {
                        Image(systemName: self.tabBarItem.imageName)
                            .font(Font(CTFont(.menuItem, size: 23)))
                            .foregroundStyle(Color.appColor(with: .spriteGreen))
                            .onTapGesture(perform: self.onTapGesture)
                    }
                    .frame(width: 30, height: 30)
            }
            .frame(width: 40, height: 40)
    }
}

struct AddTabBarButton_Preview: PreviewProvider {
    static var previews: some View {
        AddTabBarButton(onTapGesture: {})
            .previewLayout(.sizeThatFits)
    }
}
