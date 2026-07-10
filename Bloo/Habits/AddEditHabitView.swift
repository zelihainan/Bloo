//
//  AddEditHabitView.swift
//  Bloo
//

import SwiftUI

/// The "New Habit" / "Edit Habit" form (habit name, repeat days, reminder, optional
/// note). Presented as a full-screen push (not a sheet) from Home, onboarding's
/// "Your first habits" step, and Settings > Manage habits.
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
        Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date()
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
            VStack(alignment: .leading, spacing: 20) {
                Text(LocalizedStringKey(isNew ? "New Habit" : "Edit Habit"))
                    .font(.bloo(28, weight: .semibold))
                    .padding(.top, 12)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Habit name").font(.bloo(13)).foregroundStyle(.secondary)
                    TextField("", text: $name)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 18)
                        .blooFieldBackground()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Repeat").font(.bloo(13)).foregroundStyle(.secondary)
                    WeekdayPickerView(selectedDays: $selectedDays)
                        .padding(16)
                        .blooFieldBackground()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Reminder").font(.bloo(13)).foregroundStyle(.secondary)
                    reminderSection
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Note (Optional)").font(.bloo(13)).foregroundStyle(.secondary)
                    ZStack(alignment: .bottomTrailing) {
                        TextEditor(text: $note)
                            .frame(height: 100)
                            .padding(10)
                            .padding(.bottom, 16)
                            .onChange(of: note) { _, newValue in
                                if newValue.count > noteCharacterLimit {
                                    note = String(newValue.prefix(noteCharacterLimit))
                                }
                            }
                        Text("\(note.count)/\(noteCharacterLimit)")
                            .font(.bloo(11))
                            .foregroundStyle(.secondary)
                            .padding(.trailing, 12)
                            .padding(.bottom, 6)
                    }
                    .blooFieldBackground()
                }

                VStack(spacing: 10) {
                    Button {
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
                    } label: {
                        Text("Save Habit")
                            .font(.bloo(16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(accentColor.opacity(trimmedName.isEmpty || selectedDays.isEmpty ? 0.35 : 1))
                            .clipShape(RoundedRectangle(cornerRadius: BlooTheme.buttonCornerRadius, style: .continuous))
                    }
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
                .padding(.top, 8)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(BlooTheme.background)
    }

    private var reminderSection: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "bell")
                    .foregroundStyle(.secondary)
                Text("Enable reminder")
                    .font(.bloo(15))
                Spacer()
                Toggle("", isOn: $isReminderEnabled.animation())
                    .labelsHidden()
                    .tint(accentColor)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 18)

            if isReminderEnabled {
                Divider().padding(.leading, 18)
                HStack {
                    Image(systemName: "clock")
                        .foregroundStyle(.secondary)
                    Text("Time")
                        .font(.bloo(15))
                    Spacer()
                    DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 18)
            }
        }
        .blooFieldBackground()
    }
}
