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

    @State private var presentedDestination: HabitDestination?
    @State private var newCompanionName: String = ""
    @AppStorage(AppStorageKey.dailyRemindersEnabled) private var dailyRemindersEnabled = true

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

    private var accentColor: Color {
        guard let activeBloo else { return BlooTheme.primaryButtonBackground }
        return Color(hex: activeBloo.species.colorHex)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    HomeHeaderView(greeting: greeting, subtitle: "Let's build great habits together.", dayNumber: dayNumber, accentColor: accentColor)

                    if let activeBloo {
                        Spacer().frame(height: 27)
                        GrowthCardView(bloo: activeBloo)
                            .frame(maxWidth: .infinity)
                        Spacer().frame(height: 20)
                    }

                    TodayHabitsCardView(
                        habits: todaysHabits,
                        isCompleted: isCompletedToday,
                        onToggle: toggle,
                        onEdit: { presentedDestination = .edit($0) },
                        onDelete: delete,
                        onAddHabit: { presentedDestination = .new }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 52)
                .padding(.bottom, 24)
            }
            .background(BlooTheme.background)
            .navigationDestination(item: $presentedDestination) { destination in
                switch destination {
                case .new:
                    AddEditHabitView(mode: .new) { draft in save(draft: draft) }
                case .edit(let habit):
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
        rescheduleNotifications()
    }

    private func update(_ habit: Habit, with draft: HabitDraft) {
        habit.name = draft.name
        habit.note = draft.note
        habit.activeWeekdays = draft.activeWeekdays
        habit.isReminderEnabled = draft.isReminderEnabled
        habit.reminderTime = draft.reminderTime
        try? modelContext.save()
        rescheduleNotifications()
    }

    private func delete(_ habit: Habit) {
        modelContext.delete(habit)
        try? modelContext.save()
        rescheduleNotifications()
    }

    private func rescheduleNotifications() {
        NotificationScheduler.rescheduleAll(context: modelContext, dailyRemindersEnabled: dailyRemindersEnabled)
    }
}
