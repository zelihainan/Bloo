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
                        if habits.isEmpty {
                            exampleHabitPlaceholder
                        } else {
                            ForEach(Array(habits.enumerated()), id: \.element.id) { index, habit in
                                habitRow(habit)
                                    .staggeredAppear(index: index)
                            }
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
        Button {
            presentedDestination = .edit(habit)
        } label: {
            VStack(alignment: .leading, spacing: 1) {
                Text(habit.name)
                    .font(.bloo(16))
                    .foregroundStyle(BlooTheme.primaryText)
                if !habit.note.isEmpty {
                    Text(habit.note)
                        .font(.bloo(12, italic: true))
                        .foregroundStyle(BlooTheme.tertiaryText)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 14)
            .padding(.horizontal, 18)
            .blooFieldBackground()
            .contentShape(Rectangle())
        }
        .buttonStyle(.pressable)
    }

    private var exampleHabitPlaceholder: some View {
        HStack(spacing: 12) {
            Text("e.g. Drink water")
                .font(.bloo(16))
                .foregroundStyle(BlooTheme.tertiaryText)
            Spacer()
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 18)
        .background(Color.white.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous)
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4]))
                .foregroundStyle(BlooTheme.cardBorder)
        )
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
