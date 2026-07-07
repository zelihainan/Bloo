//
//  ContentView.swift
//  Bloo
//

import SwiftUI
import SwiftData

/// Temporary root view for verifying the model layer. Replaced by the onboarding/
/// tab-bar flow in the next milestone.
struct ContentView: View {
    @Query(sort: \Bloo.speciesRawValue) private var bloos: [Bloo]

    var body: some View {
        NavigationStack {
            List(bloos) { bloo in
                HStack {
                    Text(bloo.species.assetName)
                    Spacer()
                    Text(bloo.state.rawValue.capitalized)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Bloo")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Bloo.self, inMemory: true)
}
