import SwiftUI

struct CalendarView: View {
    let entries: [JournalEntry]
    var onSelectDate: (Date) -> Void

    @State private var selectedDate: Date?
    @State private var showEntriesForSelectedDate = false

    @Environment(\.dismiss) private var dismiss

    private func entriesOnDate(_ date: Date) -> [JournalEntry] {
        return entries.filter { $0.date.isSameDay(as: date) }
    }

    var body: some View {
        NavigationStack {
            VStack {
                CalendarMonthView(onSelectDate: { date in
                    selectedDate = date
                    if !entriesOnDate(date).isEmpty {
                        showEntriesForSelectedDate = true
                    }
                }, highlightedDates: entries.map { $0.date })
                
                // Show the list of entries when a date is selected
                if showEntriesForSelectedDate, let selectedDate = selectedDate {
                    VStack {
                        Text("Entries for \(selectedDate, formatter: dateFormatter)")
                            .font(.headline)
                            .padding()
                        
                        // List of entries for the selected date
                        List(entriesOnDate(selectedDate), id: \.id) { entry in
                            NavigationLink(destination: EntryDetailView(entry: entry)) {
                                Text(entry.title)
                                    .padding()
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                    .padding()
                }
            }
            .navigationTitle("Calendar View")
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

extension Date {
    func isSameDay(as otherDate: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: otherDate)
    }
}

extension Array {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}
