//
//  IconPillOption.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import Foundation

struct IconPillOption {
    var systemImage: String?
    var title: String
}

extension IconPillOption: Hashable {
    static func == (lhs: IconPillOption, rhs: IconPillOption) -> Bool {
        return lhs.title == rhs.title
    }
}
