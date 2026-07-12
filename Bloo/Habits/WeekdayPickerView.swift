//
//  WeekdayPickerView.swift
//  Bloo
//

import SwiftUI

/// The Mon...Sun toggle row plus Every Day / Weekdays / Weekends / Custom presets,
/// shared by the New/Edit Habit form.
struct WeekdayPickerView: View {
    @Binding var selectedDays: Set<Weekday>
    @Environment(\.blooAccentColor) private var accentColor

    private enum Preset: String, CaseIterable {
        case everyDay = "Every Day"
        case weekdays = "Weekdays"
        case weekends = "Weekends"
        case custom = "Custom"
    }

    private var activePreset: Preset {
        switch selectedDays {
        case Set(Weekday.allCases): .everyDay
        case Set(Weekday.weekdays): .weekdays
        case Set(Weekday.weekendDays): .weekends
        default: .custom
        }
    }

    private let presetColumns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 0) {
                ForEach(Weekday.allCases) { day in
                    let isOn = selectedDays.contains(day)
                    Button {
                        toggle(day)
                    } label: {
                        VStack(spacing: 6) {
                            Circle()
                                .fill(isOn ? accentColor : Color.gray.opacity(0.12))
                                .frame(width: 38, height: 38)
                                .overlay {
                                    if isOn {
                                        Image(systemName: "checkmark")
                                            .font(.bloo(14, weight: .bold))
                                            .foregroundStyle(.white)
                                    }
                                }
                            Text(LocalizedStringKey(day.shortLabel))
                                .font(.bloo(11))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel(Text(LocalizedStringKey(day.shortLabel)))
                    .accessibilityValue(isOn ? Text("Selected") : Text("Not selected"))
                    .accessibilityAddTraits(.isButton)
                }
            }

            LazyVGrid(columns: presetColumns, spacing: 10) {
                ForEach(Preset.allCases, id: \.self) { preset in
                    Button {
                        apply(preset)
                    } label: {
                        presetLabel(for: preset)
                    }
                }
            }
        }
    }

    private func presetLabel(for preset: Preset) -> some View {
        Text(LocalizedStringKey(preset.rawValue))
            .font(.bloo(14, weight: .medium))
            .foregroundStyle(.black)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(activePreset == preset ? accentColor : .clear, lineWidth: 1.5)
            )
    }

    private func toggle(_ day: Weekday) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
    }

    private func apply(_ preset: Preset) {
        switch preset {
        case .everyDay: selectedDays = Set(Weekday.allCases)
        case .weekdays: selectedDays = Set(Weekday.weekdays)
        case .weekends: selectedDays = Set(Weekday.weekendDays)
        case .custom: selectedDays = []
        }
    }
}
