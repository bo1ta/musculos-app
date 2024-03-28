//
//  PersonAvatarCircle.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 28.10.2023.
//

import SwiftUI

struct PersonAvatarCircle: View {
  let persons: [Person]
  var body: some View {
    let baseAvatarCircle = Circle()
      .frame(width: 40, height: 40)
      .foregroundStyle(.white)
    
    HStack(alignment: .center, spacing: -25, content: {
      ForEach(Array(persons.enumerated()), id: \.element) { index, element in
        if index > 3 {
          Circle()
            .frame(width: 40, height: 40)
            .overlay {
              Text("+\(persons.count - 4)")
                .font(.callout)
                .foregroundStyle(.gray)
            }
            .foregroundStyle(.white)
            .padding(.leading, 10)
        } else {
          AsyncImage(url: element.avatarUrl) { phase in
            switch phase {
            case .empty:
              ProgressView()
            case .success(let image):
              image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .frame(width: 60, height: 60)
            case .failure:
              baseAvatarCircle
            @unknown default:
              EmptyView()
            }
          }
        }
      }
    })
  }
}

#Preview {
  PersonAvatarCircle(persons: MockConstants.persons)
}
