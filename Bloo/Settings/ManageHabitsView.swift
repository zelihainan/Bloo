//
//  ManageHabitsView.swift
//  Bloo
//
//  Pushed full-screen from Settings (not presented as a sheet) — relies on the
//  caller providing a NavigationStack.
//

import SwiftUI
import SwiftData

/// Settings > Manage habits: full list with tap-to-edit and swipe-to-delete.
struct ManageHabitsView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage(AppStorageKey.dailyRemindersEnabled) private var dailyRemindersEnabled = true
    @Query(sort: \Habit.sortOrder) private var habits: [Habit]

    @State private var presentedDestination: HabitDestination?

    var body: some View {
        ScrollView {
            if habits.isEmpty {
                VStack(spacing: 14) {
                    ZStack {
                        Circle().fill(BlooTheme.cardBorder).frame(width: 64, height: 64)
                        Image(systemName: "list.bullet.clipboard")
                            .font(.system(size: 24))
                            .foregroundStyle(BlooTheme.secondaryText)
                    }
                    Text("No habits yet.")
                        .font(.bloo(15, weight: .medium))
                        .foregroundStyle(BlooTheme.secondaryText)

                    Button {
                        presentedDestination = .new
                    } label: {
                        Text("Add a habit")
                            .font(.bloo(14, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 22)
                            .padding(.vertical, 11)
                            .background(BlooTheme.primaryText)
                            .clipShape(Capsule())
                    }
                    .padding(.top, 4)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 100)
            } else {
                VStack(spacing: 12) {
                    ForEach(habits) { habit in
                        row(for: habit)
                    }
                }
                .padding(20)
            }
        }
        .background(BlooTheme.background)
        .navigationTitle("Manage habits")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    presentedDestination = .new
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(habits.count >= HabitStore.maxHabitCount)
            }
        }
        .navigationDestination(item: $presentedDestination) { destination in
            switch destination {
            case .new:
                AddEditHabitView(mode: .new) { draft in save(draft: draft) }
            case .edit(let habit):
                AddEditHabitView(mode: .edit(habit)) { draft in
                    update(habit, with: draft)
                } onDelete: {
                    delete(habit)
                }
            }
        }
    }

    private func row(for habit: Habit) -> some View {
        Button {
            presentedDestination = .edit(habit)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(habit.name)
                        .font(.bloo(16))
                        .foregroundStyle(.primary)
                    Text(LocalizedStringKey(scheduleSummary(for: habit)))
                        .font(.bloo(12))
                        .foregroundStyle(.secondary)
                    if !habit.note.isEmpty {
                        Text(habit.note)
                            .font(.bloo(12, italic: true))
                            .foregroundStyle(BlooTheme.tertiaryText)
                            .lineLimit(1)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.bloo(12))
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 18)
            .blooFieldBackground()
        }
        .buttonStyle(.pressable)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) { delete(habit) } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private func scheduleSummary(for habit: Habit) -> String {
        let days = Set(habit.activeWeekdays)
        if days == Set(Weekday.allCases) { return "Every day" }
        if days == Set(Weekday.weekdays) { return "Weekdays" }
        if days == Set(Weekday.weekendDays) { return "Weekends" }
        return habit.activeWeekdays.sorted { $0.rawValue < $1.rawValue }.map(\.shortLabel).joined(separator: ", ")
    }

    private func save(draft: HabitDraft) {
        HabitStore.create(draft: draft, sortOrder: habits.count, context: modelContext, dailyRemindersEnabled: dailyRemindersEnabled)
    }

    private func update(_ habit: Habit, with draft: HabitDraft) {
        HabitStore.update(habit, with: draft, context: modelContext, dailyRemindersEnabled: dailyRemindersEnabled)
    }

    private func delete(_ habit: Habit) {
        HabitStore.delete(habit, context: modelContext, dailyRemindersEnabled: dailyRemindersEnabled)
    }
}
