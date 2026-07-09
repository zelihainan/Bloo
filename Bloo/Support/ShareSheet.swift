//
//  ShareSheet.swift
//  Bloo
//

import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

/// Wraps a `String` so it can be used with `.sheet(item:)`.
struct ShareableText: Identifiable {
    let text: String
    var id: String { text }
}
