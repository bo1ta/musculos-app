//
//  MusculosLoading.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.09.2023.
//

import Foundation
import SwiftUI
import SwiftyGif

enum URLType {
    case name(String)
    case url(URL)
    
    var url: URL? {
        switch self {
        case .name(let name):
            return Bundle.main.url(forResource: name, withExtension: "gif")
        case .url(let remoteURL):
            return remoteURL
        }
    }
}

struct GIFView: UIViewRepresentable {
    @Binding var url: URL
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView(gifURL: self.url)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.setGifFromURL(self.url)
    }
}

