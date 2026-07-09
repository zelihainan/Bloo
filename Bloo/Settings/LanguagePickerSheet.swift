//
//  LanguagePickerSheet.swift
//  Bloo
//

import SwiftUI

/// Stores the preferred language (`AppStorageKey.appLanguage`). Note: this only
/// records the preference — translated copy for Turkish hasn't been added to the
/// app's strings yet, so picking Türkçe won't change any screen text yet.
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
            List(options, id: \.code) { option in
                Button {
                    selectedLanguage = option.code
                    dismiss()
                } label: {
                    HStack {
                        Text(option.label)
                            .foregroundStyle(.primary)
                        Spacer()
                        if selectedLanguage == option.code {
                            Image(systemName: "checkmark")
                                .foregroundStyle(accentColor)
                        }
                    }
                }
            }
            .navigationTitle("Language")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
