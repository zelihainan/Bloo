//
//  HomeView.swift
//  Bloo
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Bloo> { $0.stateRawValue == "active" }) private var activeBloos: [Bloo]
    @Query(sort: \Habit.sortOrder) private var allHabits: [Habit]

    @State private var presentedSheet: SheetKind?
    @State private var newCompanionName: String = ""

    private enum SheetKind: Identifiable {
        case newHabit
        case editHabit(Habit)

        var id: String {
            switch self {
            case .newHabit: "new"
            case .editHabit(let habit): habit.id.uuidString
            }
        }
    }

    private var activeBloo: Bloo? { activeBloos.first }

    private var todaysHabits: [Habit] {
        allHabits.filter { $0.isScheduled(on: Date()) }
    }

    private var dayNumber: Int {
        guard let start = activeBloo?.activatedAt else { return 1 }
        let days = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: start), to: Calendar.current.startOfDay(for: Date())).day ?? 0
        return days + 1
    }

    private var greeting: String {
        switch Calendar.current.component(.hour, from: Date()) {
        case 5..<12: "Good morning!"
        case 12..<18: "Good afternoon!"
        default: "Good evening!"
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header

                if let activeBloo {
                    GrowthCardView(bloo: activeBloo)
                        .frame(maxWidth: .infinity)
                }

                TodayHabitsCardView(
                    habits: todaysHabits,
                    isCompleted: isCompletedToday,
                    onToggle: toggle,
                    onEdit: { presentedSheet = .editHabit($0) },
                    onDelete: delete,
                    onAddHabit: { presentedSheet = .newHabit }
                )
            }
            .padding(.horizontal, 24)
            .padding(.top, 60)
            .padding(.bottom, 24)
        }
        .background(BlooTheme.background)
        .sheet(item: $presentedSheet) { sheet in
            switch sheet {
            case .newHabit:
                AddEditHabitView(mode: .new) { draft in save(draft: draft) }
            case .editHabit(let habit):
                AddEditHabitView(mode: .edit(habit)) { draft in update(habit, with: draft) } onDelete: {
                    delete(habit)
                }
            }
        }
        .sheet(isPresented: unnamedCompanionBinding) {
            if let activeBloo {
                NameBlooView(species: activeBloo.species, name: $newCompanionName) {
                    activeBloo.customName = newCompanionName.trimmingCharacters(in: .whitespacesAndNewlines)
                    try? modelContext.save()
                }
                .interactiveDismissDisabled()
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(greeting)
                    .font(.system(size: 30, weight: .semibold))
                Text("Let's build great habits together.")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("Day \(dayNumber)")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)
                .padding(.vertical, 6)
                .padding(.horizontal, 14)
                .background(Color.black.opacity(0.06))
                .clipShape(Capsule())
        }
    }

    /// Whether the active Bloo just auto-activated (after the previous one finished
    /// growing) and still needs a name.
    private var unnamedCompanionBinding: Binding<Bool> {
        Binding(
            get: { activeBloo != nil && (activeBloo?.customName?.isEmpty ?? true) },
            set: { _ in }
        )
    }

    private func isCompletedToday(_ habit: Habit) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return habit.completions.first { Calendar.current.isDate($0.date, inSameDayAs: today) }?.isCompleted ?? false
    }

    private func toggle(_ habit: Habit) {
        HabitCompletionEngine.toggleCompletion(for: habit, on: Date(), context: modelContext)
    }

    private func save(draft: HabitDraft) {
        let habit = Habit(
            name: draft.name,
            note: draft.note,
            activeWeekdays: draft.activeWeekdays,
            isReminderEnabled: draft.isReminderEnabled,
            reminderTime: draft.reminderTime,
            sortOrder: allHabits.count
        )
        modelContext.insert(habit)
        try? modelContext.save()
    }

    private func update(_ habit: Habit, with draft: HabitDraft) {
        habit.name = draft.name
        habit.note = draft.note
        habit.activeWeekdays = draft.activeWeekdays
        habit.isReminderEnabled = draft.isReminderEnabled
        habit.reminderTime = draft.reminderTime
        try? modelContext.save()
    }

    private func delete(_ habit: Habit) {
        modelContext.delete(habit)
        try? modelContext.save()
    }
}
