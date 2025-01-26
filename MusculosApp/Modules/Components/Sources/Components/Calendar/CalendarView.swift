//
//  CalendarView.swift
//  Components
//
//  Created by Solomon Alexandru on 24.11.2024.
//

import HorizonCalendar
import SwiftUI
import Utility

public struct CalendarView: View {
  @State private var calendarProxy = CalendarViewProxy()
  @State private var currentDate = Date.now

  private let startDate = DateHelper.nowPlusYears(-1)
  private let endDate = DateHelper.nowPlusYears(1)

  private var calendar: Calendar {
    Calendar.current
  }

  @Binding private var selectedDate: Date?
  private var calendarMarkers: [CalendarMarker]

  public init(selectedDate: Binding<Date?>, calendarMarkers: [CalendarMarker]) {
    _selectedDate = selectedDate
    self.calendarMarkers = calendarMarkers
  }

  public var body: some View {
    CalendarViewRepresentable(
      calendar: calendar,
      visibleDateRange: startDate ... endDate,
      monthsLayout: .horizontal(options: HorizontalMonthsLayoutOptions()),
      dataDependency: calendarMarkers,
      proxy: calendarProxy)
      .days { [calendarMarkers] day in
        if let date = calendar.date(from: day.components) {
          CalendarDay(
            date: date,
            isSelected: date == selectedDate,
            markers: filterMarkersForDate(date))
        }
      }
      .onDaySelection { day in
        updateSelectedDate(day: day)
      }
      .dayOfWeekHeaders { _, weekdayIndex in
        Text(calendar.shortWeekdaySymbols[weekdayIndex])
          .font(AppFont.poppins(.semibold, size: 16))
          .foregroundStyle(.gray)
      }
      .monthHeaders { month in
        CalendarHeader(
          title: getMonthName(month),
          subtitle: String(month.year),
          onPreviousMonth: showPreviousMonth,
          onNextMonth: showNextMonth)
      }
      .interMonthSpacing(24)
      .verticalDayMargin(8)
      .horizontalDayMargin(8)
      .layoutMargins(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
      .frame(maxWidth: .infinity)
      .onAppear {
        calendarProxy.scrollToMonth(containing: currentDate, scrollPosition: .centered, animated: false)
      }
  }

  @MainActor
  private func updateSelectedDate(day: DayComponents) {
    let date = calendar.date(from: day.components)

    if selectedDate == date {
      selectedDate = nil
    } else {
      selectedDate = date
    }
  }

  @MainActor
  private func showNextMonth() {
    guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentDate), nextMonth < endDate else {
      return
    }

    currentDate = nextMonth
    calendarProxy.scrollToMonth(containing: currentDate, scrollPosition: .centered, animated: false)
  }

  @MainActor
  private func showPreviousMonth() {
    guard let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentDate), previousMonth >= startDate else {
      return
    }

    currentDate = previousMonth
    calendarProxy.scrollToMonth(containing: currentDate, scrollPosition: .centered, animated: false)
  }

  private func filterMarkersForDate(_ date: Date) -> [CalendarMarker] {
    calendarMarkers.filter { calendar.isDate($0.date, inSameDayAs: date) }
  }

  private func getMonthName(_ month: MonthComponents) -> String {
    calendar.date(from: month.components)?.monthName() ?? ""
  }
}

#Preview {
  CalendarView(selectedDate: .constant(nil), calendarMarkers: [])
}
