//
//  HorizontalSelectPill.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import SwiftUI

struct HorizontalSelectPill: View {
    var body: some View {
        TransparentContainer {
            VStack {
                Text("Gender")
            }
        }
    }
}

struct HorizontalSelectPill_Preview: PreviewProvider {
    static var previews: some View {
        HorizontalSelectPill()
    }
}
