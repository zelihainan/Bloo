//
//  SettingsScreenView.swift
//  Bloo
//

import SwiftUI
import SwiftData
import StoreKit
import UserNotifications

struct SettingsScreenView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.blooAccentColor) private var accentColor

    @Query private var habits: [Habit]
    @Query private var bloos: [Bloo]
    @Query private var dailyLogs: [DailyLog]

    @AppStorage(AppStorageKey.dailyRemindersEnabled) private var dailyRemindersEnabled = true
    @AppStorage(AppStorageKey.defaultReminderHour) private var defaultReminderHour = 9
    @AppStorage(AppStorageKey.defaultReminderMinute) private var defaultReminderMinute = 0
    @AppStorage(AppStorageKey.appLanguage) private var appLanguage = "en"
    @AppStorage(AppStorageKey.hasCompletedOnboarding) private var hasCompletedOnboarding = true

    @State private var showsManageHabits = false
    @State private var showsLanguagePicker = false
    @State private var showsReminderTimePicker = false
    @State private var showsAbout = false
    @State private var showsClearDataConfirmation = false
    @State private var exportedCSV: String?

    private var versionString: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    private var defaultReminderTime: Date {
        Calendar.current.date(from: DateComponents(hour: defaultReminderHour, minute: defaultReminderMinute)) ?? Date()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                SettingsSectionCard(title: "Habits") {
                    SettingsRow(icon: "list.bullet.clipboard", title: "Manage habits", subtitle: "Add, edit or delete habits") {
                        showsManageHabits = true
                    }
                    Divider().padding(.leading, 66)
                    SettingsRow(icon: "globe", title: "Language", trailing: {
                        Text(appLanguage == "tr" ? "Türkçe" : "English")
                            .font(.bloo(14))
                            .foregroundStyle(.secondary)
                    }) {
                        showsLanguagePicker = true
                    }
                }

                SettingsSectionCard(title: "Notifications") {
                    SettingsRow(icon: "bell", title: "Daily reminders", showsChevron: false, trailing: {
                        Toggle("", isOn: $dailyRemindersEnabled)
                            .labelsHidden()
                            .tint(accentColor)
                            .onChange(of: dailyRemindersEnabled) { _, enabled in
                                if enabled { NotificationScheduler.requestAuthorizationIfNeeded() }
                                NotificationScheduler.rescheduleAll(context: modelContext, dailyRemindersEnabled: enabled)
                            }
                    })
                    Divider().padding(.leading, 66)
                    SettingsRow(icon: "clock", title: "Reminder time", subtitle: "Default time for new habits", trailing: {
                        Text(defaultReminderTime, style: .time)
                            .font(.bloo(14))
                            .foregroundStyle(.secondary)
                    }) {
                        showsReminderTimePicker = true
                    }
                }

                SettingsSectionCard(title: "Data") {
                    SettingsRow(icon: "square.and.arrow.down", title: "Export progress") {
                        exportedCSV = ProgressExporter.csv(habits: habits, dailyLogs: dailyLogs)
                    }
                    Divider().padding(.leading, 66)
                    SettingsRow(icon: "trash", title: "Clear all data", tint: .red) {
                        showsClearDataConfirmation = true
                    }
                }

                SettingsSectionCard(title: "About") {
                    SettingsRow(icon: "star", title: "Rate the app") {
                        requestReview()
                    }
                    Divider().padding(.leading, 66)
                    SettingsRow(icon: "info.circle", title: "About") {
                        showsAbout = true
                    }
                    Divider().padding(.leading, 66)
                    SettingsRow(icon: "number", title: "Version", showsChevron: false, trailing: {
                        Text(versionString)
                            .font(.bloo(14))
                            .foregroundStyle(.secondary)
                    })
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 60)
            .padding(.bottom, 24)
        }
        .background(BlooTheme.background)
        .sheet(isPresented: $showsManageHabits) { ManageHabitsView() }
        .sheet(isPresented: $showsLanguagePicker) { LanguagePickerSheet(selectedLanguage: $appLanguage) }
        .sheet(isPresented: $showsReminderTimePicker) {
            ReminderTimePickerSheet(hour: $defaultReminderHour, minute: $defaultReminderMinute)
        }
        .sheet(isPresented: $showsAbout) { AboutView() }
        .sheet(item: Binding(
            get: { exportedCSV.map(ShareableText.init) },
            set: { newValue in exportedCSV = newValue?.text }
        )) { item in
            ShareSheet(activityItems: [item.text])
        }
        .alert("Clear all data?", isPresented: $showsClearDataConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Clear", role: .destructive) { clearAllData() }
        } message: {
            Text("This deletes every habit, Bloo, and badge, and starts the app over from onboarding. This can't be undone.")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Settings")
                .font(.bloo(32, weight: .semibold))
            Text("Manage your Bloos and habits")
                .font(.bloo(15))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func requestReview() {
        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }
        SKStoreReviewController.requestReview(in: scene)
    }

    private func clearAllData() {
        for habit in habits { modelContext.delete(habit) }
        for bloo in bloos { modelContext.delete(bloo) }
        for log in dailyLogs { modelContext.delete(log) }
        for badge in (try? modelContext.fetch(FetchDescriptor<Badge>())) ?? [] { modelContext.delete(badge) }
        try? modelContext.save()

        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        Bloo.bootstrapSpeciesIfNeeded(in: modelContext)
        hasCompletedOnboarding = false
    }
}
