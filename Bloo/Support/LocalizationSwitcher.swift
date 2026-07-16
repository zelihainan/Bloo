import Foundation
import ObjectiveC

private var associatedBundleKey: UInt8 = 0

private final class LocalizedBundle: Bundle, @unchecked Sendable {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let languageBundle = objc_getAssociatedObject(self, &associatedBundleKey) as? Bundle else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return languageBundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

enum LocalizationSwitcher {
    static func apply(languageCode: String) {
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let languageBundle = Bundle(path: path) else {
            return
        }
        if object_getClass(Bundle.main) != LocalizedBundle.self {
            object_setClass(Bundle.main, LocalizedBundle.self)
        }
        objc_setAssociatedObject(Bundle.main, &associatedBundleKey, languageBundle, .OBJC_ASSOCIATION_RETAIN)
    }
}
