//
//  ProgressCardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.08.2023.
//

import SwiftUI

struct ProgressCardItem {
    var value: String
    var description: String
    var color: Color = .gray
}

struct ProgressCardView: View {
    var cardItem: ProgressCardItem
    var onEdit: (() -> Void)?
    
    init(cardItem: ProgressCardItem, onEdit: (() -> Void)? = nil) {
        self.cardItem = cardItem
        self.onEdit = onEdit
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(height: 80)
            .foregroundColor(cardItem.color)
            .overlay {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(cardItem.value)
                            .font(.body)
                            .fontWeight(.bold)
                        Text(cardItem.description)
                            .font(.footnote)
                    }
                    
                    Spacer()
                    
                    
                    
                    Button {
                        self.onEdit?()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.title3)
                    }
                    .padding(.bottom, 35)
                    
                }
                .padding(.horizontal, 16)
            }
    }
}

struct ProgressCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCardView(cardItem: ProgressCardItem(value: "64 kg", description: "Initial weight"), onEdit: {})
    }
}
