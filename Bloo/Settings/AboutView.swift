import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    private var versionString: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "pawprint.fill")
                    .font(.bloo(40))
                    .foregroundStyle(BlooTheme.primaryButtonBackground)
                Text("Bloo")
                    .font(.bloo(24, weight: .semibold))
                Text("Build habits. Watch it grow.")
                    .font(.bloo(15))
                    .foregroundStyle(.secondary)
                Text(String(format: NSLocalizedString("Version %@", comment: ""), versionString))
                    .font(.bloo(13))
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding(.top, 60)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BlooTheme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
