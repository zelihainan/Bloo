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

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 0) {
                ForEach(Weekday.allCases) { day in
                    let isOn = selectedDays.contains(day)
                    Button {
                        toggle(day)
                    } label: {
                        VStack(spacing: 6) {
                            Circle()
                                .fill(isOn ? accentColor : Color.gray.opacity(0.15))
                                .frame(width: 32, height: 32)
                                .overlay {
                                    if isOn {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundStyle(.white)
                                    }
                                }
                            Text(shortLabel(for: day))
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            HStack(spacing: 8) {
                ForEach(Preset.allCases, id: \.self) { preset in
                    Button(preset.rawValue) { apply(preset) }
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.black)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(activePreset == preset ? accentColor : .clear, lineWidth: 1.5)
                        )
                }
            }
        }
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
        case .custom: break
        }
    }

    private func shortLabel(for day: Weekday) -> String {
        switch day {
        case .monday: "Mon"
        case .tuesday: "Tue"
        case .wednesday: "Wed"
        case .thursday: "Thu"
        case .friday: "Fri"
        case .saturday: "Sat"
        case .sunday: "Sun"
        }
    }
}
