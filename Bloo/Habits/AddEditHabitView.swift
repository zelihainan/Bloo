//
//  AddEditHabitView.swift
//  Bloo
//

import SwiftUI

/// The "New Habit" / "Edit Habit" form (habit name, repeat days, reminder, optional
/// note). Used both from onboarding's "Your first habits" step and later from
/// Settings > Manage habits.
struct AddEditHabitView: View {
    enum Mode {
        case new
        case edit(Habit)
    }

    let mode: Mode
    let onSave: (HabitDraft) -> Void
    var onDelete: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.blooAccentColor) private var accentColor

    @State private var name: String
    @State private var selectedDays: Set<Weekday>
    @State private var isReminderEnabled: Bool
    @State private var reminderTime: Date
    @State private var note: String

    private let noteCharacterLimit = 120

    private static func defaultReminderTime() -> Date {
        let hour = UserDefaults.standard.object(forKey: AppStorageKey.defaultReminderHour) as? Int ?? 9
        let minute = UserDefaults.standard.object(forKey: AppStorageKey.defaultReminderMinute) as? Int ?? 0
        return Calendar.current.date(from: DateComponents(hour: hour, minute: minute)) ?? Date()
    }

    init(mode: Mode, onSave: @escaping (HabitDraft) -> Void, onDelete: (() -> Void)? = nil) {
        self.mode = mode
        self.onSave = onSave
        self.onDelete = onDelete
        switch mode {
        case .new:
            _name = State(initialValue: "")
            _selectedDays = State(initialValue: Set(Weekday.allCases))
            _isReminderEnabled = State(initialValue: false)
            _reminderTime = State(initialValue: Self.defaultReminderTime())
            _note = State(initialValue: "")
        case .edit(let habit):
            _name = State(initialValue: habit.name)
            _selectedDays = State(initialValue: Set(habit.activeWeekdays))
            _isReminderEnabled = State(initialValue: habit.isReminderEnabled)
            _reminderTime = State(initialValue: habit.reminderTime)
            _note = State(initialValue: habit.note)
        }
    }

    private var isNew: Bool {
        if case .new = mode { true } else { false }
    }

    private var trimmedName: String { name.trimmingCharacters(in: .whitespacesAndNewlines) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.bloo(18, weight: .medium))
                        .foregroundStyle(.black)
                        .padding(10)
                        .background(Color.white)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(BlooTheme.cardBorder, lineWidth: 1))
                }
                .padding(.top, 8)

                Text(isNew ? "New Habit" : "Edit Habit")
                    .font(.bloo(30, weight: .semibold))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Habit name").font(.bloo(14)).foregroundStyle(.secondary)
                    TextField("", text: $name)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 18)
                        .blooFieldBackground()
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Repeat").font(.bloo(14)).foregroundStyle(.secondary)
                    WeekdayPickerView(selectedDays: $selectedDays)
                        .padding(16)
                        .blooFieldBackground()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Reminder").font(.bloo(14)).foregroundStyle(.secondary)
                    HStack {
                        Image(systemName: "bell")
                            .foregroundStyle(.secondary)
                        DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                        Spacer()
                        Toggle("", isOn: $isReminderEnabled)
                            .labelsHidden()
                            .tint(accentColor)
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 18)
                    .blooFieldBackground()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Note (Optional)").font(.bloo(14)).foregroundStyle(.secondary)
                    TextEditor(text: $note)
                        .frame(height: 100)
                        .padding(10)
                        .blooFieldBackground()
                        .onChange(of: note) { _, newValue in
                            if newValue.count > noteCharacterLimit {
                                note = String(newValue.prefix(noteCharacterLimit))
                            }
                        }
                    Text("\(note.count)/\(noteCharacterLimit)")
                        .font(.bloo(12))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }

                Spacer(minLength: 12)

                Button("Save Habit") {
                    onSave(
                        HabitDraft(
                            name: trimmedName,
                            note: note,
                            activeWeekdays: Array(selectedDays),
                            isReminderEnabled: isReminderEnabled,
                            reminderTime: reminderTime
                        )
                    )
                    dismiss()
                }
                .buttonStyle(.bloo(isEnabled: !trimmedName.isEmpty && !selectedDays.isEmpty))
                .disabled(trimmedName.isEmpty || selectedDays.isEmpty)

                if let onDelete {
                    Button("Delete Habit") {
                        onDelete()
                        dismiss()
                    }
                    .font(.bloo(16, weight: .semibold))
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .blooFieldBackground()
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(BlooTheme.background)
    }
}
