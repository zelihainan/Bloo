//
//  MiniToggle.swift
//  Bloo
//
//  A custom-sized toggle matching Figma exactly (36x20 track, 16x16 knob) —
//  the native SwiftUI Toggle renders at ~51x31 and can't be resized that way.
//

import SwiftUI

struct MiniToggle: View {
    @Binding var isOn: Bool
    var tint: Color

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            ZStack(alignment: isOn ? .trailing : .leading) {
                Capsule().fill(isOn ? tint : BlooTheme.cardBorder)
                Circle().fill(.white).padding(2)
            }
            .frame(width: 36, height: 20)
        }
        .buttonStyle(.plain)
    }
}
