import SwiftData
import os

extension ModelContext {
    func saveAndLogErrors() {
        do {
            try save()
        } catch {
            Logger(subsystem: "com.zelihainan.Bloo", category: "persistence")
                .error("ModelContext.save() failed: \(error, privacy: .public)")
        }
    }
}
