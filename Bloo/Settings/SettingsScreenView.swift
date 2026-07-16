//
//  SettingsScreenView.swift
//  Bloo
//
//  Values from the Figma REST API (node 17:118): title 28px regular, subtitle
//  13px #8A8278; trailing values 6px #B0A898; divider #F8F5F0; toggle is a
//  custom 36x20 track (MiniToggle), not the native ~51x31 UISwitch size.
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
    @AppStorage(AppStorageKey.appLanguage) private var appLanguage = "en"
    @AppStorage(AppStorageKey.hasCompletedOnboarding) private var hasCompletedOnboarding = true

    @State private var showsManageHabits = false
    @State private var showsLanguagePicker = false
    @State private var showsAbout = false
    @State private var showsClearDataConfirmation = false
    @State private var showsExportPreview = false
    @State private var isSystemAuthorized = true
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header

                    SettingsSectionCard(title: "Habits") {
                        SettingsRow(icon: "list.bullet.clipboard", title: "Manage habits", subtitle: "Add, edit or delete habits") {
                            showsManageHabits = true
                        }
                        divider
                        SettingsRow(icon: "globe", title: "Language", trailing: {
                            trailingValue(appLanguage == "tr" ? "Türkçe" : "English")
                        }) {
                            showsLanguagePicker = true
                        }
                    }
                    .padding(.horizontal, 28)

                    SettingsSectionCard(title: "Notifications") {
                        SettingsRow(
                            icon: "bell",
                            title: "Daily reminders",
                            subtitle: isSystemAuthorized ? "Turn off to silence every habit's reminder" : "Notifications are turned off in iOS Settings",
                            showsChevron: false,
                            trailing: {
                                MiniToggle(isOn: $dailyRemindersEnabled, tint: accentColor)
                                    .accessibilityLabel(Text("Daily reminders"))
                                    .onChange(of: dailyRemindersEnabled) { _, enabled in
                                        if enabled { NotificationScheduler.requestAuthorizationIfNeeded() }
                                        NotificationScheduler.rescheduleAll(context: modelContext, dailyRemindersEnabled: enabled)
                                    }
                            }
                        )
                    }
                    .padding(.horizontal, 28)

                    SettingsSectionCard(title: "Data") {
                        SettingsRow(icon: "square.and.arrow.down", title: "Export progress") {
                            showsExportPreview = true
                        }
                        divider
                        SettingsRow(icon: "trash", title: "Clear all data") {
                            showsClearDataConfirmation = true
                        }
                    }
                    .padding(.horizontal, 28)

                    SettingsSectionCard(title: "About") {
                        SettingsRow(icon: "star", title: "Rate the app") {
                            requestReview()
                        }
                        divider
                        SettingsRow(icon: "info.circle", title: "About") {
                            showsAbout = true
                        }
                    }
                    .padding(.horizontal, 28)
                }
                .padding(.bottom, 24)
            }
            .background(BlooTheme.background)
            .navigationDestination(isPresented: $showsManageHabits) { ManageHabitsView() }
            .sheet(isPresented: $showsLanguagePicker) { LanguagePickerSheet(selectedLanguage: $appLanguage) }
            .sheet(isPresented: $showsAbout) { AboutView() }
            .sheet(isPresented: $showsExportPreview) { ExportPreviewView(habits: habits, dailyLogs: dailyLogs) }
            .alert("Clear all data?", isPresented: $showsClearDataConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Clear", role: .destructive) { clearAllData() }
            } message: {
                Text("This deletes every habit, Bloo, and badge, and starts the app over from onboarding. This can't be undone.")
            }
            .task { await refreshNotificationAuthorization() }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    Task { await refreshNotificationAuthorization() }
                }
            }
        }
    }

    /// The in-app toggle is just an `@AppStorage` flag, so it can drift from
    /// what iOS actually allows (denied at the system prompt, or revoked later
    /// from Settings) — reflect the real authorization status whenever this
    /// screen becomes visible instead of letting the toggle silently lie.
    private func refreshNotificationAuthorization() async {
        let authorized = await NotificationScheduler.isAuthorized()
        isSystemAuthorized = authorized
        if dailyRemindersEnabled && !authorized {
            dailyRemindersEnabled = false
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Settings")
                .font(.bloo(28))
                .foregroundStyle(BlooTheme.primaryText)
            Text("Manage your Bloos and habits")
                .font(.bloo(13))
                .foregroundStyle(BlooTheme.secondaryText)
        }
        .padding(.leading, 28)
        .padding(.top, 47.5)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var divider: some View {
        Rectangle()
            .fill(Color(hex: "#F8F5F0"))
            .frame(height: 1)
            .padding(.leading, 62)
    }

    private func trailingValue(_ text: String) -> some View {
        Text(text)
            .font(.bloo(11))
            .foregroundStyle(BlooTheme.tertiaryText)
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
        modelContext.saveAndLogErrors()

        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        Bloo.bootstrapSpeciesIfNeeded(in: modelContext)
        hasCompletedOnboarding = false
    }
}
