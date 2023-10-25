//
//  View+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.08.2023.
//

import Foundation
import SwiftUI

extension View {
    func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
        self.modifier(TabBarItemViewModifier(tab: tab, selection: selection))
    }
    
    @ViewBuilder
    func makeBackgroundView(@ViewBuilder content: () -> some View, with buttonStack: (() -> some View)? = nil) -> some View {
        ZStack(alignment: .bottom) {
            Image("weightlifting-background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .overlay {
                    Color.black
                        .opacity(0.8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                }
            
            content()
                .padding(4)
            
            if let buttonStack = buttonStack {
                buttonStack()
            }
        }
    }
}
