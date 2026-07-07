//
//  OnboardingWelcomeView.swift
//  Bloo
//

import SwiftUI

struct OnboardingWelcomeView: View {
    let onContinue: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Spacer().frame(height: 60)

            Text("Something is hatching...")
                .font(.bloo(32, weight: .semibold))
                .foregroundStyle(.black)
            Text("Build habits. Watch it grow.")
                .font(.bloo(17))
                .foregroundStyle(.secondary)

            Spacer()

            EggPlaceholderView()
                .frame(width: 220, height: 220)
                .frame(maxWidth: .infinity)

            Spacer()
            Spacer()

            Button("Get started", action: onContinue)
                .buttonStyle(.bloo())
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BlooTheme.background)
    }
}

#Preview {
    OnboardingWelcomeView(onContinue: {})
}
