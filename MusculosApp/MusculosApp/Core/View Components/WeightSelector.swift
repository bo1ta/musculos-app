//
//  WeightSelector.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 28.06.2023.
//

import SwiftUI

struct WeightSelector: View {
    let weights: [Int] = Array(50...200)
    @State private var selectedWeight: Int = 100
    @State private var scrollViewSize: CGSize = .zero
    @State private var isScrolling: Bool = false

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollViewReaderProxy in
                HStack(spacing: 20) {
                    ForEach(weights, id: \.self) { weight in
                        Text("\(weight) kg")
                            .font(.title)
                            .foregroundColor(.black)
                            .id(weight)
                            .onTapGesture {
                                withAnimation {
                                    selectedWeight = weight
                                    isScrolling = true
                                }
                                scrollViewReaderProxy.scrollTo(weight, anchor: .center)
                            }
                    }
                }
                .padding(.horizontal, (scrollViewSize.width - 100) / 2)
                .onChange(of: selectedWeight) { _ in
                    if isScrolling {
                        isScrolling = false
                    } else {
                        withAnimation {
                            scrollViewReaderProxy.scrollTo(selectedWeight, anchor: .center)
                        }
                    }
                }
                .onAppear {
                    scrollViewReaderProxy.scrollTo(selectedWeight, anchor: .center)
                }
            }
        }
    }
}



struct HWeightSelector_Preview: PreviewProvider {
    static var previews: some View {
        WeightSelector()
    }
}
