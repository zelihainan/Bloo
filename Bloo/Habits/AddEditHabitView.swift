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
    var onArchiveToggle: ((Bool) -> Void)?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.blooAccentColor) private var accentColor
    @Environment(\.modelContext) private var modelContext

    @State private var name: String
    @State private var selectedDays: Set<Weekday>
    @State private var isReminderEnabled: Bool
    @State private var reminderTime: Date
    @State private var note: String
    @State private var showsDeleteConfirmation = false

    private let nameCharacterLimit = 40
    private let noteCharacterLimit = 120

    private static func defaultReminderTime() -> Date {
        Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date()
    }

    init(mode: Mode, onSave: @escaping (HabitDraft) -> Void, onDelete: (() -> Void)? = nil, onArchiveToggle: ((Bool) -> Void)? = nil) {
        self.mode = mode
        self.onSave = onSave
        self.onDelete = onDelete
        self.onArchiveToggle = onArchiveToggle
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

    private var editingHabit: Habit? {
        if case .edit(let habit) = mode { habit } else { nil }
    }

    /// Today first, walking backward — matches the reading order of the row.
    private var recentHistoryDates: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }
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
                        .onChange(of: name) { _, newValue in
                            if newValue.count > nameCharacterLimit {
                                name = String(newValue.prefix(nameCharacterLimit))
                            }
                        }
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

                if let editingHabit {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recent history").font(.bloo(13)).foregroundStyle(.secondary)
                        recentHistoryRow(for: editingHabit)
                            .padding(16)
                            .blooFieldBackground()
                    }
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
                            .font(.bloo(14, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(accentColor.opacity(trimmedName.isEmpty || selectedDays.isEmpty ? 0.35 : 1))
                            .clipShape(RoundedRectangle(cornerRadius: BlooTheme.buttonCornerRadius, style: .continuous))
                    }
                    .disabled(trimmedName.isEmpty || selectedDays.isEmpty)

                    if let editingHabit, let onArchiveToggle {
                        VStack(spacing: 6) {
                            Button(editingHabit.isArchived ? "Restore Habit" : "Archive Habit") {
                                onArchiveToggle(!editingHabit.isArchived)
                                dismiss()
                            }
                            .font(.bloo(14, weight: .semibold))
                            .foregroundStyle(.orange)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .blooFieldBackground()

                            if !editingHabit.isArchived {
                                Text("Paused — won't show on Home or send reminders until restored")
                                    .font(.bloo(11))
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }

                    if onDelete != nil {
                        Button("Delete Habit") {
                            showsDeleteConfirmation = true
                        }
                        .font(.bloo(14, weight: .semibold))
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .blooFieldBackground()
                    }
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(BlooTheme.background)
        .alert("Delete this habit?", isPresented: $showsDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                onDelete?()
                dismiss()
            }
        } message: {
            Text("This can't be undone.")
        }
    }

    /// Missed a day? Tap it here to backfill — the Home checkbox only ever
    /// operates on "today", so this is the only way to fix a forgotten day.
    private func recentHistoryRow(for habit: Habit) -> some View {
        HStack(spacing: 0) {
            ForEach(recentHistoryDates, id: \.self) { date in
                let isScheduled = habit.isScheduled(on: date)
                let isCompleted = habit.completions.first { Calendar.current.isDate($0.date, inSameDayAs: date) }?.isCompleted ?? false

                Button {
                    HabitCompletionEngine.toggleCompletionAndCascade(for: habit, on: date, context: modelContext)
                } label: {
                    VStack(spacing: 4) {
                        Circle()
                            .fill(isCompleted ? accentColor : Color.gray.opacity(0.12))
                            .frame(width: 28, height: 28)
                            .overlay {
                                if isCompleted {
                                    Image(systemName: "checkmark")
                                        .font(.bloo(11, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                            }
                        Text(LocalizedStringKey(dayInitial(for: date)))
                            .font(.bloo(10, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                }
                .disabled(!isScheduled)
                .opacity(isScheduled ? 1 : 0.35)
                .frame(maxWidth: .infinity)
                .accessibilityLabel(Text(date.formatted(date: .abbreviated, time: .omitted)))
                .accessibilityValue(isCompleted ? Text("Completed") : Text("Not completed"))
                .accessibilityAddTraits(.isButton)
            }
        }
    }

    private func dayInitial(for date: Date) -> String {
        guard let weekday = Weekday(gregorianCalendarWeekday: Calendar.current.component(.weekday, from: date)) else { return "" }
        return weekday.shortLabel
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
