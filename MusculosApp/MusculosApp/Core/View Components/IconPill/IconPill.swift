//
//  IconPill.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import SwiftUI

enum IconPillSize {
    case small, medium, large
}

struct IconPill: View {
    private let option: IconPillOption
    private let iconPillSize: IconPillSize = .small
    
    init(option: IconPillOption) {
        self.option = option
    }
    
    private var systemImageSize: CGFloat {
        guard self.option.systemImage != nil else { return 0 }
        
        /// `ImageScale.small
        return 40.0
    }
    
    private var fontSizeWidth: CGFloat {
        return self.option.title.widthOfString(usingFont: .systemFont(ofSize: 12))
    }
    
    private var rectangleWidth: CGFloat {
        var multiplier = 1
        switch self.iconPillSize {
        case .small:
            return (self.systemImageSize + self.fontSizeWidth + 20) / 2 + 20
        case .medium, .large:
            break
        }
        return self.systemImageSize + self.fontSizeWidth + 20
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .foregroundColor(.gray)
            .opacity(0.2)
            .frame(minWidth: self.rectangleWidth, minHeight: 25)
            .overlay {
                VStack(alignment: .center) {
                    HStack(spacing: 3) {
                        if let systemImage = self.option.systemImage {
                            Image(systemName: systemImage)
                                .imageScale(.small)
                                .foregroundColor(.white)
                        }
                       
                        Text(self.option.title)
                            .foregroundColor(.white)
                            .font(Font(CTFont(.smallToolbar, size: 10)))
                    }
                    .fixedSize()
                }
            }
            .fixedSize()
    }
}

struct IconPill_Preview: PreviewProvider {
    static var previews: some View {
        IconPill(option: IconPillOption(title: "1x / week", systemImage: "clock"))
            .previewLayout(.sizeThatFits)
    }
}
