//
//  ManageHabitsView.swift
//  Bloo
//
//  Pushed full-screen from Settings (not presented as a sheet) — relies on the
//  caller providing a NavigationStack.
//

import SwiftUI
import SwiftData

/// Settings > Manage habits: full list with tap-to-edit, swipe-to-archive, and
/// swipe-to-delete, plus a separate section for paused (archived) habits.
struct ManageHabitsView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage(AppStorageKey.dailyRemindersEnabled) private var dailyRemindersEnabled = true
    @Query(sort: \Habit.sortOrder) private var allHabits: [Habit]

    @State private var presentedDestination: HabitDestination?

    private var activeHabits: [Habit] { allHabits.filter { !$0.isArchived } }
    private var archivedHabits: [Habit] { allHabits.filter(\.isArchived) }

    var body: some View {
        ScrollView {
            if allHabits.isEmpty {
                Text("No habits yet.")
                    .font(.bloo(15))
                    .foregroundStyle(.secondary)
                    .padding(.top, 40)
            } else {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(spacing: 12) {
                        ForEach(activeHabits) { habit in
                            row(for: habit, isArchived: false)
                        }
                    }

                    if !archivedHabits.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Archived")
                                .font(.bloo(13, weight: .medium))
                                .foregroundStyle(.secondary)
                            VStack(spacing: 12) {
                                ForEach(archivedHabits) { habit in
                                    row(for: habit, isArchived: true)
                                }
                            }
                        }
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
                .disabled(activeHabits.count >= HabitStore.maxHabitCount)
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
                } onArchiveToggle: { archived in
                    setArchived(habit, archived: archived)
                }
            }
        }
    }

    private func row(for habit: Habit, isArchived: Bool) -> some View {
        Button {
            presentedDestination = .edit(habit)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(habit.name)
                        .font(.bloo(16))
                        .foregroundStyle(isArchived ? .secondary : .primary)
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
            .opacity(isArchived ? 0.6 : 1)
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) { delete(habit) } label: {
                Label("Delete", systemImage: "trash")
            }
            Button {
                setArchived(habit, archived: !isArchived)
            } label: {
                if isArchived {
                    Label("Restore", systemImage: "arrow.uturn.backward")
                } else {
                    Label("Archive", systemImage: "archivebox")
                }
            }
            .tint(.orange)
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
        HabitStore.create(draft: draft, sortOrder: allHabits.count, context: modelContext, dailyRemindersEnabled: dailyRemindersEnabled)
    }

    private func update(_ habit: Habit, with draft: HabitDraft) {
        HabitStore.update(habit, with: draft, context: modelContext, dailyRemindersEnabled: dailyRemindersEnabled)
    }

    private func delete(_ habit: Habit) {
        HabitStore.delete(habit, context: modelContext, dailyRemindersEnabled: dailyRemindersEnabled)
    }

    private func setArchived(_ habit: Habit, archived: Bool) {
        HabitStore.setArchived(habit, archived: archived, context: modelContext, dailyRemindersEnabled: dailyRemindersEnabled)
    }
}
