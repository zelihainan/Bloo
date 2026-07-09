//
//  ReminderTimePickerSheet.swift
//  Bloo
//

import SwiftUI

/// Sets the default reminder time pre-filled when creating a new habit.
struct ReminderTimePickerSheet: View {
    @Binding var hour: Int
    @Binding var minute: Int
    @Environment(\.dismiss) private var dismiss

    @State private var time: Date

    init(hour: Binding<Int>, minute: Binding<Int>) {
        self._hour = hour
        self._minute = minute
        let initial = Calendar.current.date(from: DateComponents(hour: hour.wrappedValue, minute: minute.wrappedValue)) ?? Date()
        self._time = State(initialValue: initial)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Default time for new habits' reminders.")
                    .font(.bloo(14))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()

                Spacer()
            }
            .padding(24)
            .background(BlooTheme.background)
            .navigationTitle("Reminder time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
                        hour = components.hour ?? 9
                        minute = components.minute ?? 0
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
