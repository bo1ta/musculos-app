//
//  CustomNavigationBar.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import SwiftUI

struct CustomNavigationBar: View {
    private let onBack: () -> Void
    private let onContinue: () -> Void
    
    init(onBack: @escaping () -> Void, onContinue: @escaping () -> Void) {
        self.onBack = onBack
        self.onContinue = onContinue
    }
    
    var body: some View {
        HStack {
            IconButtonView(systemImage: "lessthan", action: self.onBack)
                .padding([.leading], 10)
                .padding([.top, .bottom], 10)
            Spacer()
            Button(action: self.onContinue, label: {
                Text("Skip")
                    .foregroundStyle(.white)
            })
            .padding([.trailing], 15)
        }
        .background(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)).opacity(0.5).foregroundColor(.gray))
    }
}

struct CustomNavigation_Preview: PreviewProvider {
    static var previews: some View {
        CustomNavigationBar(onBack: {}, onContinue: {})
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
