//
//  SettingsRow.swift
//  Bloo
//

import SwiftUI

/// One row inside a `SettingsSectionCard`: icon, title, optional subtitle, optional
/// trailing content (a toggle, a value label, ...), optional chevron, optional tap action.
struct SettingsRow<Trailing: View>: View {
    let icon: String
    let title: String
    var subtitle: String? = nil
    var showsChevron: Bool = true
    var tint: Color? = nil
    @ViewBuilder var trailing: () -> Trailing
    var action: (() -> Void)? = nil

    @Environment(\.blooAccentColor) private var accentColor

    private var rowColor: Color { tint ?? accentColor }

    var body: some View {
        Button {
            action?()
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(rowColor.opacity(0.12))
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .font(.bloo(15))
                        .foregroundStyle(rowColor)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.bloo(15))
                        .foregroundStyle(tint ?? .primary)
                    if let subtitle {
                        Text(subtitle)
                            .font(.bloo(12))
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                trailing()
                if showsChevron {
                    Image(systemName: "chevron.right")
                        .font(.bloo(12))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(action == nil)
    }
}

extension SettingsRow where Trailing == EmptyView {
    init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        showsChevron: Bool = true,
        tint: Color? = nil,
        action: (() -> Void)? = nil
    ) {
        self.init(icon: icon, title: title, subtitle: subtitle, showsChevron: showsChevron, tint: tint, trailing: { EmptyView() }, action: action)
    }
}
