//
//  CalendarMonthView.swift
//  MemoryBoard
//
//  Created by Khumar Girdhar on 06/11/24.
//

import SwiftUI

struct CalendarMonthView: View {
    let onSelectDate: (Date) -> Void
    let highlightedDates: [Date]

    @State private var currentDate = Date()

    private let calendar = Calendar.current
    
    private var firstDayOfMonth: Date {
        return calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
    }

    private var daysInMonth: [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate) else { return [] }
        return range.compactMap { day -> Date? in
            return calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)
        }
    }

    private var leadingEmptySpaces: Int {
        let weekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
        return weekday == 0 ? 6 : weekday - 1
    }

    private var daysForGrid: [Date?] {
        var allDays: [Date?] = Array(repeating: nil, count: leadingEmptySpaces)
        allDays.append(contentsOf: daysInMonth)
        return allDays
    }

    private func isHighlighted(date: Date) -> Bool {
        highlightedDates.contains { $0.isSameDay(as: date) }
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.left")
                }

                Spacer()

                Text(currentDate, formatter: monthYearFormatter)
                    .font(.headline)

                Spacer()

                Button(action: {
                    currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()

            HStack {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                    Text(day).frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(daysForGrid, id: \.self) { date in
                    if let date = date {
                        VStack {
                            Text("\(calendar.component(.day, from: date))")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding()
                                .background(isHighlighted(date: date) ? Color.blue.opacity(0.5) : Color.clear)
                                .clipShape(Circle())
                                .font(.system(size: 16, weight: .bold))
                                .frame(minWidth: 40, minHeight: 40)
                        }
                        .onTapGesture {
                            onSelectDate(date)
                        }
                    } else {
                        VStack { Text("") }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .padding([.top, .bottom], 8)
        }
    }

    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}
