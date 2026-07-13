//
//  OnboardingBackButton.swift
//  Bloo
//
//  Onboarding steps aren't hosted in a NavigationStack (they're swapped via a
//  simple state machine in OnboardingContainerView), so there's no system back
//  button — this is the manual equivalent, shared so every step looks the same.
//

import SwiftUI

struct OnboardingBackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.black)
                .frame(width: 44, height: 44)
                .modifier(BackButtonGlassBackground())
        }
        .buttonStyle(.pressable)
    }
}

/// Matches the circular glass back button iOS 26 renders automatically for
/// screens pushed in a real `NavigationStack` (e.g. Manage Habits) — onboarding
/// isn't hosted in one, so this replicates the same look manually.
private struct BackButtonGlassBackground: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.glassEffect(.regular, in: Circle())
        } else {
            content
                .background(Color.white)
                .clipShape(Circle())
        }
    }
}
