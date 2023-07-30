//
//  MiniCardWheel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.07.2023.
//

import SwiftUI

struct MiniCardWheel: View {
    private let items: [MiniCardItem]
    
    init(items: [MiniCardItem]) {
        self.items = items
    }
    
    var body: some View {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(items, id: \.self) { item in
                            MiniCard(item: item)
                }

                }
            }
            .frame(height: 200)
        }
}

struct MiniCardWheel_Preview: PreviewProvider {
    static var previews: some View {
        MiniCardWheel(items: [
            MiniCardItem(title: "Hello", subtitle: "hello", description: "hello", iconPillOption: IconPillOption(title: "Hei")),
            MiniCardItem(title: "Hello", subtitle: "hello", description: "hello", iconPillOption: nil),
            MiniCardItem(title: "Hello", subtitle: "hello", description: "hello", iconPillOption: nil),
            MiniCardItem(title: "Hello", subtitle: "hello", description: "hello", iconPillOption: nil),
            MiniCardItem(title: "Hello", subtitle: "hello", description: "hello", iconPillOption: nil),
            MiniCardItem(title: "Hello", subtitle: "hello", description: "hello", iconPillOption: nil),
            MiniCardItem(title: "Hello", subtitle: "hello", description: "hello", iconPillOption: nil)
        ])
    }
}
