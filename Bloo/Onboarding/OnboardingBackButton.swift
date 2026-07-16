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
