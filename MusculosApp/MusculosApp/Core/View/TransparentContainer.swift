//
//  TransparentContainer.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import SwiftUI

struct TransparentContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            VStack {
                content
                    .padding()
                    .fixedSize(horizontal: false, vertical: true) 
            }
            .background(Color.gray)
            .cornerRadius(10)
            .opacity(0.5)
            .padding()
        }
    }
}
