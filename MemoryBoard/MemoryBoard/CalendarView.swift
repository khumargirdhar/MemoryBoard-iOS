import SwiftUI
import CoreData

struct CalendarView: View {
    let entries: [JournalEntry]
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: JournalViewModel
    let onSelectDate: (Date) -> Void

    @State private var selectedDate: Date?
    @State private var showEntriesForSelectedDate = false
    @Environment(\.dismiss) private var dismiss
    
    init(entries: [JournalEntry], onSelectDate: @escaping (Date) -> Void = { _ in }) {
        self.entries = entries
        self.onSelectDate = onSelectDate
        _viewModel = StateObject(wrappedValue: JournalViewModel(context: CoreDataManager.shared.viewContext))
    }

    private func entriesOnDate(_ date: Date) -> [JournalEntry] {
        return entries.filter { entry in
            guard let entryDate = entry.date else { return false }
            return Calendar.current.isDate(entryDate, inSameDayAs: date)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                CalendarMonthView(onSelectDate: { date in
                    selectedDate = date
                    showEntriesForSelectedDate = true
                }, highlightedDates: entries.compactMap { $0.date })
                
                if let selectedDate = selectedDate {
                    let entriesOnSelectedDate = entriesOnDate(selectedDate)
                    if !entriesOnSelectedDate.isEmpty {
                        List {
                            ForEach(entriesOnSelectedDate) { entry in
                                NavigationLink(destination: EntryDetailView(entry: entry)) {
                                    VStack(alignment: .leading) {
                                        Text(entry.title ?? "")
                                            .font(.headline)
                                        Text(entry.content ?? "")
                                            .font(.subheadline)
                                            .lineLimit(2)
                                    }
                                }
                            }
                        }
                    } else {
                        Text("No entries for this date")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
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
