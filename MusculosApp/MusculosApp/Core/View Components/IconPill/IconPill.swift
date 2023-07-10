//
//  IconPill.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import SwiftUI

struct IconPill: View {
    private let option: IconPillOption
    
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
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .foregroundColor(.gray)
            .opacity(0.6)
            .frame(minWidth: self.systemImageSize + self.fontSizeWidth + 20, minHeight: 25)
            .overlay {
                VStack(alignment: .center) {
                    HStack {
                        if let systemImage = self.option.systemImage {
                            Image(systemName: systemImage)
                                .imageScale(.small)
                                .foregroundColor(.white)
                        }
                       
                        Text(self.option.title)
                            .foregroundColor(.white)
                            .font(.caption)
                    }
                    .fixedSize()
                }
            }
            .fixedSize()
    }
}

struct IconPill_Preview: PreviewProvider {
    static var previews: some View {
        IconPill(option: IconPillOption(systemImage: "clock", title: "1x / week"))
            .previewLayout(.sizeThatFits)
    }
}
