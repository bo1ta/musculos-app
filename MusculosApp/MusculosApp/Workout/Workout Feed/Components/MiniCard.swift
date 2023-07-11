//
//  CardItem.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.07.2023.
//

import SwiftUI

struct MiniCardItem {
    let title: String
    let subtitle: String
    let description: String
    
    let iconPillOption: IconPillOption?
}

struct MiniCard: View {
    
    private let item: MiniCardItem
    
    init(item: MiniCardItem) {
        self.item = item
    }
    
    var body: some View {
        RoundedRectangle(cornerSize: CGSize(width: 30, height: 15))
            .frame(maxWidth: 150, maxHeight: 150)
            .foregroundColor(.orange)
            .overlay {
                VStack(alignment: .leading, spacing: 5) {
                    Text(item.title)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    Text(item.subtitle)
                        .font(.caption2)
                        .foregroundColor(.white)
                        .fontWeight(.light)
                    Spacer()
                    Text(item.description)
                        .font(.callout)
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                    
                    if let iconPillOption = self.item.iconPillOption {
                        IconPill(option: iconPillOption)
                            .padding(.bottom, 5)
                    }
                }
            }
    }
}

struct CardItem_Preview: PreviewProvider {
    static var previews: some View {
        MiniCard(item: MiniCardItem(title: "Featured workout",
                                        subtitle: "Gym workout",
                                        description: "Body contouring",
                                        iconPillOption: IconPillOption(title: "In progress"))
        )
    }
}
