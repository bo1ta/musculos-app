//
//  CalendarView.swift
//  Components
//
//  Created by Solomon Alexandru on 24.11.2024.
//

import SwiftUI
import UIKit
import HorizonCalendar
import Utility

public struct CalendarView: View {
  @Binding private var selectedDate: Date?
  @Binding private var calendarMarkers: [CalendarMarker]

  private var calendar: Calendar {
    return Calendar.current
  }

  let startDate = DateHelper.nowPlusDays(-14)
  let endDate = Date.now

  public init(selectedDate: Binding<Date?>, calendarMarkers: Binding<[CalendarMarker]>) {
    self._selectedDate = selectedDate
    self._calendarMarkers = calendarMarkers
  }

  public var body: some View {
    CalendarViewRepresentable(
      calendar: Calendar.current,
      visibleDateRange: startDate...endDate,
      monthsLayout: .horizontal(options: HorizontalMonthsLayoutOptions()),
      dataDependency: calendarMarkers
    )
    .days { day in
      let date = calendar.date(from: day.components)
      let isSelected = date == selectedDate

      if isSelected {
        RoundedRectangle(cornerRadius: 12)
          .foregroundStyle(AppColor.navyBlue)
          .overlay {
            makeDayText(day, isSelected: true)
          }
      } else {
        makeDayText(day)
      }

      if let date = date, let markers = getMarkersForDate(date) {
        makeMarkers(markers)
      }
    }
    .dayOfWeekHeaders({ _, weekdayIndex in
      Text(calendar.shortWeekdaySymbols[weekdayIndex])
        .font(AppFont.poppins(.semibold, size: 16))
        .foregroundStyle(.gray)
    })
    .interMonthSpacing(24)
    .verticalDayMargin(8)
    .horizontalDayMargin(8)
    .onDaySelection({ day in
      let date = calendar.date(from: day.components)

      if selectedDate == date {
        selectedDate = nil
      } else {
        selectedDate = date
      }
    })
    .monthHeaders({ month in
      makeMonthHeader(month)
    })
    .layoutMargins(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
    .padding(.horizontal, 16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private func getMarkersForDate(_ date: Date) -> [CalendarMarker]? {
    let markers = calendarMarkers.filter { calendar.isDate($0.date, inSameDayAs: date) }
    return markers.isEmpty ? nil : markers
  }

  private func makeMarkers(_ markers: [CalendarMarker]) -> some View {
    HStack(spacing: 4) {
      ForEach(markers) { marker in
        Circle()
          .frame(width: 6, height: 6)
          .foregroundColor(marker.color)
      }
    }
  }

  private func makeMonthHeader(_ month: MonthComponents) -> some View {
    HStack {
      Spacer()

      VStack {
        Text(calendar.date(from: month.components)?.monthName() ?? "")
          .font(AppFont.spartan(.bold, size: 24))
          .foregroundStyle(.black)
        Text(String(month.year))
          .font(AppFont.spartan(.regular, size: 18))
          .foregroundStyle(.gray)
      }

      Spacer()
    }
  }

  private func makeDayText(_ day: DayComponents, isSelected: Bool = false) -> some View {
    Text("\(day.day)")
      .font(AppFont.poppins(isSelected ? .bold : .regular, size: isSelected ? 18.0 : 16.0))
      .foregroundStyle(isSelected ? .white : .black)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
  CalendarView(selectedDate: .constant(nil), calendarMarkers: .constant([]))
}
