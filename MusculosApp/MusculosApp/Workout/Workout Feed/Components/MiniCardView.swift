//
//  MiniCardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.07.2023.
//

import SwiftUI

struct MiniCardItem {
    let id = UUID().uuidString
    let title: String
    let subtitle: String
    let description: String
    let imageName: String?
    let color: Color?
    let iconPillOption: IconPillOption?

    init(title: String, subtitle: String, description: String, imageName: String? = nil, color: Color? = nil, iconPillOption: IconPillOption? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.imageName = imageName
        self.color = color
        self.iconPillOption = iconPillOption
    }
}

extension MiniCardItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

struct MiniCardView: View {
    private let size: CGFloat?
    private let item: MiniCardItem

    init(item: MiniCardItem, size: CGFloat? = 150) {
        self.item = item
        self.size = size
    }

    var body: some View {
        self.roundedRectangle
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
                        .padding(.bottom, item.iconPillOption != nil ? 0 : 30)

                    if let iconPillOption = self.item.iconPillOption {
                        IconPill(option: iconPillOption)
                            .padding(.bottom, 5)
                    }
                }
                .padding(5)
            }
    }

    @ViewBuilder
    private var roundedRectangle: some View {
        let shadowRadius = 5.0
        let roundedRectangle = RoundedRectangle(cornerRadius: 25.0)

        if let imageName = item.imageName {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .clipShape(roundedRectangle)
                .shadow(radius: shadowRadius)
        } else {
            roundedRectangle
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundColor(item.color ?? .orange)
                .shadow(radius: shadowRadius)
        }
    }
}

struct MiniCardItem_Preview: PreviewProvider {
    static var previews: some View {
        MiniCardView(item: MiniCardItem(title: "Featured workout", subtitle: "Gym workout", description: "Body contouring", imageName: "workout-crunches", iconPillOption: IconPillOption(title: "In progress")))
            .previewLayout(.sizeThatFits)
    }
}
