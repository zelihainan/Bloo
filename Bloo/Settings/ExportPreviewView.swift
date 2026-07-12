//
//  ExportPreviewView.swift
//  Bloo
//
//  Settings > Export progress: a summary preview before sharing, so the user
//  sees what they're about to send instead of blindly generating a CSV.
//

import SwiftUI

struct ExportPreviewView: View {
    let habits: [Habit]
    let dailyLogs: [DailyLog]

    @Environment(\.dismiss) private var dismiss
    @Environment(\.blooAccentColor) private var accentColor
    @State private var showsShareSheet = false

    private var summary: ProgressSummary { ProgressExporter.summary(habits: habits, dailyLogs: dailyLogs) }
    private var reportText: String { ProgressExporter.report(habits: habits, dailyLogs: dailyLogs) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    statsCard
                    if !summary.habitStreaks.isEmpty {
                        habitsCard
                    }

                    Button {
                        showsShareSheet = true
                    } label: {
                        Text("Share Report")
                            .font(.bloo(15, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: BlooTheme.buttonCornerRadius, style: .continuous))
                    }
                    .padding(.top, 4)
                }
                .padding(20)
            }
            .background(BlooTheme.background)
            .navigationTitle("Export progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showsShareSheet) {
                ShareSheet(activityItems: [reportText])
            }
        }
    }

    private var statsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let trackingSince = summary.trackingSince {
                statRow(label: "Tracking since", value: trackingSince.formatted(date: .abbreviated, time: .omitted))
                Divider()
            }
            statRow(label: "Days logged", value: "\(summary.daysLogged)")
            Divider()
            statRow(label: "Total XP earned", value: "\(summary.totalXP)")
            Divider()
            statRow(label: "Perfect days", value: "\(summary.perfectDays)")
            Divider()
            statRow(label: "Longest streak", value: streakLabel(summary.longestStreak))
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous)
                .stroke(BlooTheme.cardBorder, lineWidth: 1)
        )
    }

    private var habitsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Habits")
                .font(.bloo(13, weight: .medium))
                .foregroundStyle(BlooTheme.secondaryText)
            ForEach(summary.habitStreaks, id: \.name) { entry in
                HStack {
                    Text(entry.name)
                        .font(.bloo(14))
                        .foregroundStyle(BlooTheme.primaryText)
                    Spacer()
                    Text(streakLabel(entry.streak))
                        .font(.bloo(12, weight: .medium))
                        .foregroundStyle(accentColor.mixed(withBlack: 0.3))
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous)
                .stroke(BlooTheme.cardBorder, lineWidth: 1)
        )
    }

    private func streakLabel(_ days: Int) -> String {
        let format = days == 1 ? NSLocalizedString("%d Day", comment: "") : NSLocalizedString("%d Days", comment: "")
        return String(format: format, days)
    }

    private func statRow(label: String, value: String) -> some View {
        HStack {
            Text(LocalizedStringKey(label))
                .font(.bloo(14))
                .foregroundStyle(BlooTheme.secondaryText)
            Spacer()
            Text(value)
                .font(.bloo(14, weight: .semibold))
                .foregroundStyle(BlooTheme.primaryText)
        }
    }
}
