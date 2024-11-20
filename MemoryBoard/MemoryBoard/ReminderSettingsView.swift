import SwiftUI
import UserNotifications

struct ReminderSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("reminderTimeDouble") private var reminderTimeDouble: Double = Date().timeIntervalSince1970
    @AppStorage("isReminderEnabled") private var isReminderEnabled: Bool = false
    
    // Create a binding wrapper for the time
    private var timeBinding: Binding<Date> {
        Binding(
            get: { Date(timeIntervalSince1970: self.reminderTimeDouble) },
            set: { newDate in
                self.reminderTimeDouble = newDate.timeIntervalSince1970
                scheduleNotification()
            }
        )
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Enable Daily Reminder", isOn: $isReminderEnabled)
                        .onChange(of: isReminderEnabled) { value in
                            if value {
                                requestNotificationPermission()
                            } else {
                                cancelNotifications()
                            }
                        }
                    
                    if isReminderEnabled {
                        DatePicker("Reminder Time",
                                 selection: timeBinding,
                                 displayedComponents: .hourAndMinute)
                    }
                } header: {
                    Text("Daily Journal Reminder")
                } footer: {
                    Text("You'll receive a daily notification to write in your journal at your selected time.")
                }
            }
            .navigationTitle("Reminder Settings")
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
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    scheduleNotification()
                } else {
                    isReminderEnabled = false
                }
            }
        }
    }
    
    private func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        
        // Cancel existing notifications
        center.removeAllPendingNotificationRequests()
        
        // Create new notification
        let content = UNMutableNotificationContent()
        content.title = "Time to Journal"
        content.body = "Take a moment to reflect on your day and write in your journal."
        content.sound = .default
        
        // Create calendar components from selected time
        let currentDate = Date(timeIntervalSince1970: reminderTimeDouble)
        let components = Calendar.current.dateComponents([.hour, .minute], from: currentDate)
        
        // Create trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        // Create request
        let request = UNNotificationRequest(identifier: "journalReminder",
                                          content: content,
                                          trigger: trigger)
        
        // Schedule notification
        center.add(request)
    }
    
    private func cancelNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
} 