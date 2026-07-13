//
//  StaggeredAppear.swift
//  Bloo
//
//  A one-off fade + slide-up entrance for items in a list/grid, staggered by
//  index so items appear in sequence rather than all at once.
//

import SwiftUI

private struct StaggeredAppearModifier: ViewModifier {
    let index: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .opacity(appeared || reduceMotion ? 1 : 0)
            .offset(y: appeared || reduceMotion ? 0 : 12)
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(.easeOut(duration: 0.35).delay(Double(index) * 0.06)) {
                    appeared = true
                }
            }
    }
}

extension View {
    /// Fades and slides this view in, delayed by `index * 0.06s` — for staggering
    /// items in a list/grid so they appear in sequence. No-ops under Reduce Motion.
    func staggeredAppear(index: Int) -> some View {
        modifier(StaggeredAppearModifier(index: index))
    }
}
