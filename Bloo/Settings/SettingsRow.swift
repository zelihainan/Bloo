//
//  SettingsRow.swift
//  Bloo
//
//  Values from the Figma REST API (node 17:118): icon circle 30x30 radius8
//  (a rounded square, not a circle) filled with the dynamic accent pastel;
//  icon 15x15; title 10px medium — in the SECONDARY color, not primary;
//  subtitle/trailing value 6px #B0A898; chevron '›' 13px #C8BFB4.
//

import SwiftUI

/// One row inside a `SettingsSectionCard`: icon, title, optional subtitle, optional
/// trailing content (a toggle, a value label, ...), optional chevron, optional tap action.
///
/// When `action` is nil the row isn't wrapped in a Button at all — nesting an
/// interactive `trailing` control (like a toggle) inside a disabled Button
/// would disable that control too.
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
        if let action {
            Button(action: action) { rowContent }
                .buttonStyle(.plain)
        } else {
            rowContent
        }
    }

    private var rowContent: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(rowColor.mixed(withWhite: 0.92))
                    .frame(width: 38, height: 38)
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundStyle(rowColor)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(LocalizedStringKey(title))
                    .font(.bloo(14, weight: .medium))
                    .foregroundStyle(tint ?? BlooTheme.secondaryText)
                if let subtitle {
                    Text(LocalizedStringKey(subtitle))
                        .font(.bloo(11))
                        .foregroundStyle(BlooTheme.tertiaryText)
                }
            }
            Spacer()
            trailing()
            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(hex: "#C8BFB4"))
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .contentShape(Rectangle())
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
