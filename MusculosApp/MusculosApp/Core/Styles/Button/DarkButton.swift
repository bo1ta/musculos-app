//
//  DarkButton.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 14.08.2023.
//

import Foundation
import SwiftUI

struct DarkButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(16)
            .fixedSize(horizontal: false, vertical: true)
            .background(.black)
            .foregroundColor(.white)
            .fontWeight(.semibold)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 24, height: 20)))
    }
}
