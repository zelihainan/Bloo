//
//  LanguagePickerSheet.swift
//  Bloo
//

import SwiftUI

/// A compact sheet with app-styled rows (not a bare system List, not a context menu).
struct LanguagePickerSheet: View {
    @Binding var selectedLanguage: String
    @Environment(\.dismiss) private var dismiss
    @Environment(\.blooAccentColor) private var accentColor

    private let options: [(code: String, label: String)] = [
        ("en", "English"),
        ("tr", "Türkçe"),
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                ForEach(options, id: \.code) { option in
                    row(for: option)
                }
                Spacer()
            }
            .padding(20)
            .padding(.top, 8)
            .background(BlooTheme.background)
            .navigationTitle("Language")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.height(260)])
    }

    private func row(for option: (code: String, label: String)) -> some View {
        let isSelected = selectedLanguage == option.code
        return Button {
            selectedLanguage = option.code
            dismiss()
        } label: {
            HStack {
                Text(option.label)
                    .font(.bloo(15, weight: .medium))
                    .foregroundStyle(BlooTheme.primaryText)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(accentColor)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 18)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous)
                    .stroke(isSelected ? accentColor : BlooTheme.cardBorder, lineWidth: isSelected ? 1.5 : 1)
            )
        }
        .buttonStyle(.pressable)
    }
}
