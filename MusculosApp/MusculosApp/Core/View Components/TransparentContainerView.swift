//
//  TransparentContainerView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import SwiftUI

struct TransparentContainerView<Content: View>: View {
    let content: Content
    
    @State private var contentHeight: CGFloat = 0
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Color.gray
                .opacity(0.4)
                .cornerRadius(10)
                .padding([.leading, .trailing], 5)
            
            VStack {
                content
                    .padding()
                    .background( // calculate transparent container height
                        GeometryReader { scrollViewGeometry in
                            Color.clear
                                .onAppear(perform: {
                                    contentHeight += 40 + scrollViewGeometry.size.height
                                })
                        }
                    )
            }
            .padding()
        }
        .frame(maxHeight: contentHeight)
    }
}
