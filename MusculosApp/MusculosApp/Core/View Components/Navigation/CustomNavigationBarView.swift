//
//  CustomNavigationBarView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import SwiftUI

struct CustomNavigationBarView: View {
    private let onBack: (() -> Void)?
    private let onContinue: (() -> Void)?
    private let title: String?
    private let isPresented: Bool?
    private let rightBarButton: IconButtonView?
    
    init(title: String? = nil, rightBarButton: IconButtonView? = nil, isPresented: Bool? = false, onBack: (() -> Void)?, onContinue: (() -> Void)?) {
        self.onBack = onBack
        self.onContinue = onContinue
        self.title = title
        self.isPresented = isPresented
        self.rightBarButton = rightBarButton
    }
    
    var body: some View {
        HStack {
            if let onBack = self.onBack {
                IconButtonView(systemImage: "lessthan", action: onBack)
                    .padding([.leading], 10)
                    .padding([.top, .bottom], 10)
            }
            Spacer()
            
            if self.isPresented == true {
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 60, height: 5)
                        .foregroundColor(.white)
                        .fixedSize(horizontal: true, vertical: true)
                        .padding(.bottom, 5)
                    
                    if let title = self.title {
                        Text(title)
                            .foregroundColor(.white)
                            .font(.title)
                            .padding(.bottom, 5)
                    }
                }
                .fixedSize(horizontal: true, vertical: true)
                .padding(5)
            } else {
                if let title = self.title {
                    Text(title)
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.bottom, 5)
                }
            }
            
            Spacer()
            
            if let onContinue = self.onContinue {
                if let rightBarButton = self.rightBarButton {
                    rightBarButton
                        .padding([.trailing], 10)
                        .padding([.top, .bottom], 10)
                } else {
                    Button(action: onContinue, label: {
                        Text("Skip")
                            .foregroundStyle(.white)
                    })
                    .padding([.trailing], 15)
                }
            }
        }
        .background(RoundedRectangle(cornerRadius: 20).opacity(0.5).foregroundColor(.gray))
    }
}

struct CustomNavigationBarView_Preview: PreviewProvider {
    static var previews: some View {
        CustomNavigationBarView(title: "Filters", onBack: nil, onContinue: nil)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
