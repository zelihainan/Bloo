//
//  OnboardingAddHabitsView.swift
//  Bloo
//

import SwiftUI
import SwiftData

struct OnboardingAddHabitsView: View {
    let onBack: () -> Void
    let onContinue: () -> Void

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.sortOrder) private var habits: [Habit]

    @State private var presentedDestination: HabitDestination?
    @AppStorage(AppStorageKey.dailyRemindersEnabled) private var dailyRemindersEnabled = true

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 8) {
                Spacer().frame(height: 12)
                OnboardingBackButton(action: onBack)
                Spacer().frame(height: 20)

                Text("Your first habits")
                    .font(.bloo(32, weight: .semibold))
                Text("Start small. Bloo will remind you.")
                    .font(.bloo(17))
                    .foregroundStyle(.secondary)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(habits) { habit in
                            habitRow(habit)
                        }
                    }
                    .padding(.top, 24)
                }

                HStack {
                    Spacer()
                    Button {
                        presentedDestination = .new
                    } label: {
                        Label("Add a habit", systemImage: "plus.circle.fill")
                            .font(.bloo(15, weight: .semibold))
                            .foregroundStyle(.black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 18)
                            .background(Color.black.opacity(0.06))
                            .clipShape(Capsule())
                    }
                    .disabled(habits.count >= HabitStore.maxHabitCount)
                    Spacer()
                }
                .padding(.vertical, 12)

                Spacer()

                Button("Continue", action: onContinue)
                    .buttonStyle(.bloo(isEnabled: !habits.isEmpty))
                    .disabled(habits.isEmpty)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BlooTheme.background)
            .navigationDestination(item: $presentedDestination) { destination in
                switch destination {
                case .new:
                    AddEditHabitView(mode: .new) { draft in
                        save(draft: draft, sortOrder: habits.count)
                    }
                case .edit(let habit):
                    AddEditHabitView(mode: .edit(habit)) { draft in
                        update(habit, with: draft)
                    } onDelete: {
                        delete(habit)
                    }
                }
            }
        }
    }

    private func habitRow(_ habit: Habit) -> some View {
        HStack(spacing: 12) {
            Text(habit.name)
                .font(.bloo(16))
            Spacer()
            Button {
                presentedDestination = .edit(habit)
            } label: {
                Image(systemName: "pencil")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 18)
        .blooFieldBackground()
    }

    private func save(draft: HabitDraft, sortOrder: Int) {
        HabitStore.create(draft: draft, sortOrder: sortOrder, context: modelContext, dailyRemindersEnabled: dailyRemindersEnabled)
    }

    private func update(_ habit: Habit, with draft: HabitDraft) {
        HabitStore.update(habit, with: draft, context: modelContext, dailyRemindersEnabled: dailyRemindersEnabled)
    }

    private func delete(_ habit: Habit) {
        HabitStore.delete(habit, context: modelContext, dailyRemindersEnabled: dailyRemindersEnabled)
    }
}
