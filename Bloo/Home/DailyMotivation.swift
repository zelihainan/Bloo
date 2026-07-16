//
//  DailyMotivation.swift
//  Bloo
//
//  The subtitle under Home's greeting rotates through a small pool of
//  motivational lines — one per calendar day (not per app launch), so it
//  stays the same all day and only changes tomorrow.
//

import Foundation

enum DailyMotivation {
    private static let en = [
        "Let's build great habits together.",
        "Small steps, big changes.",
        "Every day is a fresh start.",
        "Progress, not perfection.",
        "You've got this — one habit at a time.",
        "Consistency beats intensity.",
        "Show up for yourself today.",
        "Little by little, a little becomes a lot.",
        "Today is a good day to grow.",
        "Keep going — Bloo's counting on you.",
    ]

    private static let tr = [
        "Birlikte harika alışkanlıklar oluşturalım.",
        "Küçük adımlar, büyük değişimler.",
        "Her gün yeni bir başlangıç.",
        "Mükemmellik değil, ilerleme.",
        "Bunu yapabilirsin — bir seferde bir alışkanlık.",
        "İstikrar, hızdan daha güçlüdür.",
        "Bugün kendin için burada ol.",
        "Azar azar, çok olur.",
        "Bugün büyümek için güzel bir gün.",
        "Devam et — Bloo sana güveniyor.",
    ]

    /// `languageCode` mirrors how the rest of the app resolves the in-app
    /// language (`AppStorageKey.appLanguage`), not the system locale — those
    /// two can differ once the user picks a language from Settings.
    static func quote(for date: Date = Date(), languageCode: String) -> String {
        let pool = languageCode == "tr" ? tr : en
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
        return pool[dayOfYear % pool.count]
    }
}
