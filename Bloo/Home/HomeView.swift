import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Bloo> { $0.stateRawValue == "active" }) private var activeBloos: [Bloo]
    @Query(sort: \Habit.sortOrder) private var allHabits: [Habit]

    @State private var presentedDestination: HabitDestination?
    @State private var newCompanionName: String = ""
    @State private var xpPopup: HabitXPPopup?
    @State private var showsNameSheet = false
    @State private var newlyEarnedBadge: BadgeType?
    @AppStorage(AppStorageKey.dailyRemindersEnabled) private var dailyRemindersEnabled = true
    @AppStorage(AppStorageKey.appLanguage) private var appLanguage = "en"

    @State private var now = Date()
    @State private var hasAppearedOnce = false
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var activeBloo: Bloo? { activeBloos.first }

    private var todaysHabits: [Habit] {
        allHabits.filter { $0.isScheduled(on: now) }
    }

    private var dayNumber: Int {
        guard let start = activeBloo?.activatedAt else { return 1 }
        let days = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: start), to: Calendar.current.startOfDay(for: now)).day ?? 0
        return days + 1
    }

    private var greeting: String {
        switch Calendar.current.component(.hour, from: now) {
        case 5..<12: "Good morning!"
        case 12..<18: "Good afternoon!"
        default: "Good evening!"
        }
    }

    private var accentColor: Color {
        guard let activeBloo else { return BlooTheme.primaryButtonBackground }
        return Color(hex: activeBloo.species.colorHex)
    }

    private var motivationalSubtitle: String {
        DailyMotivation.quote(for: now, languageCode: appLanguage)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    HomeHeaderView(greeting: greeting, subtitle: motivationalSubtitle, dayNumber: dayNumber, accentColor: accentColor)

                    if let activeBloo {
                        Spacer().frame(height: 27)
                        GrowthCardView(bloo: activeBloo)
                            .frame(maxWidth: .infinity)
                            .transaction { transaction in
                                if !hasAppearedOnce { transaction.animation = nil }
                            }
                        Spacer().frame(height: 20)
                    }

                    TodayHabitsCardView(
                        habits: todaysHabits,
                        totalHabitCount: allHabits.count,
                        isCompleted: isCompletedToday,
                        onToggle: toggle,
                        onEdit: { presentedDestination = .edit($0) },
                        onDelete: delete,
                        onAddHabit: { presentedDestination = .new },
                        xpPopup: xpPopup
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
            .sheet(isPresented: $showsNameSheet) {
                if let activeBloo {
                    NameBlooView(species: activeBloo.species, name: $newCompanionName, celebratesUnlock: true) {
                        activeBloo.customName = newCompanionName.trimmingCharacters(in: .whitespacesAndNewlines)
                        modelContext.saveAndLogErrors()
                        showsNameSheet = false
                    }
                }
            }
            .overlay(alignment: .top) {
                if let newlyEarnedBadge {
                    BadgeUnlockToastView(badge: newlyEarnedBadge)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        .onAppear {
            updateNameSheetVisibility()
            DispatchQueue.main.async { hasAppearedOnce = true }
        }
        .onChange(of: activeBloo?.id) { _, _ in updateNameSheetVisibility() }
        .onChange(of: activeBloo?.customName) { _, _ in updateNameSheetVisibility() }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active { now = Date() }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in
            now = Date()
        }
    }

    private func updateNameSheetVisibility() {
        showsNameSheet = activeBloo != nil && (activeBloo?.customName?.isEmpty ?? true)
    }

    private func isCompletedToday(_ habit: Habit) -> Bool {
        let today = Calendar.current.startOfDay(for: now)
        return habit.completions.first { Calendar.current.isDate($0.date, inSameDayAs: today) }?.isCompleted ?? false
    }

    private func toggle(_ habit: Habit) {
        let xpBefore = activeBloo?.xp ?? 0
        let badgesBefore = Set((try? modelContext.fetch(FetchDescriptor<Badge>()).map(\.type)) ?? [])

        HabitCompletionEngine.toggleCompletion(for: habit, on: now, context: modelContext)

        let delta = (activeBloo?.xp ?? 0) - xpBefore
        if delta > 0 {
            let popup = HabitXPPopup(habitID: habit.id, amount: delta)
            xpPopup = popup
            Task {
                try? await Task.sleep(for: .seconds(1))
                if xpPopup?.id == popup.id {
                    xpPopup = nil
                }
            }
        }

        let badgesAfter = Set((try? modelContext.fetch(FetchDescriptor<Badge>()).map(\.type)) ?? [])
        if let newBadge = badgesAfter.subtracting(badgesBefore).first {
            withAnimation(reduceMotion ? nil : .spring(response: 0.45, dampingFraction: 0.75)) {
                newlyEarnedBadge = newBadge
            }
            Task {
                try? await Task.sleep(for: .seconds(2.6))
                withAnimation(reduceMotion ? nil : .easeIn(duration: 0.3)) {
                    if newlyEarnedBadge == newBadge {
                        newlyEarnedBadge = nil
                    }
                }
            }
        }
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
}
