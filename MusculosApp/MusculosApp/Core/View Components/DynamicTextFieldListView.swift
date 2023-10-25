//
//  CustomListView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.10.2023.
//

import SwiftUI

struct DynamicTextFieldListView: View {
    @Binding private var items: [Int: String]

    init(items: Binding<[Int: String]> = .constant([:])) {
        self._items = items
    }

    var body: some View {
        ScrollView {
            ZStack {
                if !items.isEmpty {
                    RoundedRectangle(cornerRadius: 38)
                        .fill(.white)
                }
                self.listView
            }
            Button {
                print("hei")
                self.items[self.items.count] = ""
            } label: {
                Text("Add")

            }
        }
    }

    @ViewBuilder
    private var listView: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(self.items.keys.sorted(), id: \.self) { index in
                TextField("", text: Binding(get: {
                    self.items[index, default: ""]
                }, set: { newValue in
                    self.items[index] = newValue
                }))
                .foregroundStyle(.black)
                .padding(.leading, 15)

                self.listDivider
                    .padding(.bottom, 10)
                    .padding(.leading, 15)
            }
            Spacer()
        }
        .foregroundStyle(.black)
        .padding(.top, 15)
    }

    @ViewBuilder
    private var listDivider: some View {
        VStack {
            Color.black.frame(height: 1 / UIScreen.main.scale)
        }
    }
}

#Preview {
    DynamicTextFieldListView()
}
