//
//  LanguagePickerSheet.swift
//  Bloo
//

import SwiftUI

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
