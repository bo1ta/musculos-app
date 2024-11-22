//
//  EquipmentCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.10.2024.
//

import SwiftUI
import Utility
import Models

struct EquipmentCard: View {
  let equipmentType: ExerciseConstants.EquipmentType

    var body: some View {
      RoundedRectangle(cornerRadius: 18)
        .foregroundStyle(.white)
        .shadow(radius: 1)
        .frame(maxWidth: .infinity)
        .frame(height: 70)
        .overlay {
          HStack {
            VStack(alignment: .leading, spacing: 2) {
              Text("Category")
                .shadow(radius: 0.2)
                .font(AppFont.poppins(.regular, size: 14))
                .foregroundStyle(.gray)

              HStack {
                Image(equipmentType.imageName)
                  .resizable()
                  .renderingMode(.template)
                  .aspectRatio(contentMode: .fit)
                  .frame(height: 18)
                  .rotationEffect(Angle(degrees: 45))
                  .foregroundStyle(equipmentType.color)
                Text(equipmentType.title)
                  .font(AppFont.poppins(.semibold, size: 13))
                  .foregroundStyle(equipmentType.color)
              }
            }

            Spacer()
          }
          .padding(.horizontal)
        }
    }
}

#Preview {
  EquipmentCard(equipmentType: .barbell)
}
