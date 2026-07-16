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
        .contentShape(Rectangle().inset(by: -12))
        .accessibilityAddTraits(.isButton)
        .accessibilityValue(isOn ? Text("On") : Text("Off"))
    }
}
