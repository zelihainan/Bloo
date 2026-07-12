//
//  PressableButtonStyle.swift
//  Bloo
//
//  Consistent tactile press feedback for the app's custom (non-chrome) buttons —
//  a drop-in replacement for .buttonStyle(.plain) that adds a subtle scale-down.
//

import SwiftUI

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PressableButtonStyle {
    static var pressable: PressableButtonStyle { PressableButtonStyle() }
}
