//
//  ModelContext+Save.swift
//  Bloo
//

import SwiftData
import os

extension ModelContext {
    /// Saves and logs any failure instead of silently discarding it — a bare
    /// `try? context.save()` gives no visibility if a write fails (disk
    /// pressure, a corrupted store, ...), which previously meant a completed
    /// habit or earned XP could vanish with nothing in the logs to explain why.
    func saveAndLogErrors() {
        do {
            try save()
        } catch {
            Logger(subsystem: "com.zelihainan.Bloo", category: "persistence")
                .error("ModelContext.save() failed: \(error, privacy: .public)")
        }
    }
}
