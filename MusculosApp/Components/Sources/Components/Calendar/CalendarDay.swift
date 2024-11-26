//
//  CalendarDay.swift
//  Components
//
//  Created by Solomon Alexandru on 26.11.2024.
//

import SwiftUI
import Utility
import Foundation

struct CalendarDay: View {
  let date: Date
  let isSelected: Bool
  let markers: [CalendarMarker]

  public init(date: Date, isSelected: Bool, markers: [CalendarMarker]) {
    self.date = date
    self.isSelected = isSelected
    self.markers = markers
  }

  var body: some View {
    if isSelected {
      RoundedRectangle(cornerRadius: 12)
        .foregroundStyle(AppColor.navyBlue)
        .overlay {
          dayLabel
        }
    } else {
      dayLabel
    }
  }

  private var dayLabel: some View {
    VStack(spacing: 0) {
      Text("\(date.day)")
        .font(AppFont.poppins(isSelected ? .bold : .regular, size: isSelected ? 18.0 : 16.0))
        .foregroundStyle(isSelected ? .white : .black)
        .frame(maxWidth: .infinity, maxHeight: .infinity)

      if !markers.isEmpty {
        HStack(spacing: 0) {
          ForEach(markers) { marker in
            Circle()
              .frame(height: 8)
              .foregroundColor(marker.color)
          }
        }
        .padding(.vertical, -1)
      }
    }
  }
}
