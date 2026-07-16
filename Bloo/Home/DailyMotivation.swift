import Foundation

enum DailyMotivation {
    private static let en = [
        "Let's build great habits together.",
        "Small steps, big changes.",
        "Every day is a fresh start.",
        "Progress, not perfection.",
        "Consistency beats intensity.",
        "Show up for yourself today.",
        "Today is a good day to grow.",
        "Keep going, Bloo's counting on you.",
        "One small action can change your whole day.",
        "Your future self will thank you.",
        "A little progress is still progress.",
        "Make today count.",
        "Habits grow stronger every time you return.",
        "Start small, but start today.",
        "Keep the promise you made to yourself.",
        "Your effort matters, even when it feels small.",
        "Bloo believes in you.",
        "One completed habit is one step forward.",
        "You are building something meaningful.",
        "Don't break the rhythm.",
        "A fresh opportunity begins today.",
        "Be proud of showing up.",
        "Your journey is made of small victories.",
        "Keep growing at your own pace.",
        "Today's effort becomes tomorrow's strength.",
        "You are closer than you were yesterday.",
        "Let's make Bloo proud today.",
    ]

    private static let tr = [
        "Birlikte harika alışkanlıklar oluşturalım.",
        "Küçük adımlar, büyük değişimler.",
        "Her gün yeni bir başlangıç.",
        "Mükemmellik değil, ilerleme.",
        "İstikrar, yoğunluktan daha güçlüdür.",
        "Bugün kendin için burada ol.",
        "Bugün gelişmek için güzel bir gün.",
        "Devam et, Bloo sana güveniyor.",
        "Küçük bir hareket bütün gününü değiştirebilir.",
        "Gelecekteki halin sana teşekkür edecek.",
        "Küçük bir ilerleme de ilerlemedir.",
        "Bugünü değerli kıl.",
        "Her geri döndüğünde alışkanlıkların güçlenir.",
        "Küçük başla ama bugün başla.",
        "Kendine verdiğin sözü tut.",
        "Küçük görünse bile çaban önemlidir.",
        "Bloo sana inanıyor.",
        "Tamamlanan her alışkanlık ileriye atılmış bir adımdır.",
        "Anlamlı bir şey inşa ediyorsun.",
        "Ritmini kaybetme.",
        "Bugün yeni bir fırsat başlıyor.",
        "Burada olduğun için kendinle gurur duy.",
        "Yolculuğun küçük zaferlerden oluşuyor.",
        "Kendi hızında gelişmeye devam et.",
        "Bugünün çabası yarının gücüne dönüşür.",
        "Düne göre hedeflerine daha yakınsın.",
        "Bugün Bloo'yu gururlandıralım.",
    ]

    static func quote(for date: Date = Date(), languageCode: String) -> String {
        let pool = languageCode == "tr" ? tr : en
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
        return pool[dayOfYear % pool.count]
    }
}
