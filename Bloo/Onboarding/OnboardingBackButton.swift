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
                .font(.bloo(15, weight: .semibold))
                .foregroundStyle(.secondary)
        }
    }
}
