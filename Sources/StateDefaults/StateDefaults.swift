import Foundation
@propertyWrapper
public
class StateDefaults<Value>: ObservableObject where Value : Equatable {
    
    
    private var storage: UserDefaults!
    private let key: String
    private let fileManager = FileManager()
    private let preferencesURL: URL
    private var fileMonitor: FileWriteMonitor?
    @Published private var value: Value
    
    public init(
        _ key: String,
        defaultValue: Value,
        userDefaults: UserDefaults? = .standard
    ) {
        self.key = key
        self.preferencesURL = getPlistURL(fileManager: fileManager)
        self.storage = userDefaults
        
        defer {
            NotificationCenter.default
                .addObserver(
                    self,
                    selector: #selector(didReciveUpdate),
                    name: UserDefaults.didChangeNotification,
                    object: .none)
        }
        
        
        // handle default value
        
        if let valueFromStorage = storage.object(forKey: key) as? Value {
            self._value = Published(wrappedValue: valueFromStorage)
        }
        else {
            self._value = Published(wrappedValue: defaultValue)
            storage.set(defaultValue, forKey: key)
        }
        
        self.fileMonitor = FileWriteMonitor(preferencesURL) { [weak self] in
            self?.defaultsPlistChanged()
        }
        
    }
    
    public var wrappedValue: Value {
        get {
            value
        }
        set {
            self.value = newValue
            storage.set(newValue, forKey: key)
        }
    }
    
    @objc private func didReciveUpdate() {
        if let newValue = storage.object(forKey: key) as? Value,
            value != newValue {
            self.value = newValue
        }
    }
    private func defaultsPlistChanged() {
        guard
            let plist = try? getPlist(plistURL: preferencesURL),
            let newValue = plist[key] as? Value,
            value != newValue
            else { return }
        
        if storage.object(forKey: key) as? Value != newValue {
            storage.set(newValue, forKey: self.key)
            self.value = newValue
        }
    }
}


// MARK: - Private helper
private func getPlistURL(fileManager: FileManager) -> URL {
    guard
        let bundleID = Bundle.main.bundleIdentifier,
        let preferences = try? fileManager
            .url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: .none, create: false)
            .appendingPathComponent("Preferences/\(bundleID).plist")
        else { fatalError("Could not find the preferences folder.") }
    
    return preferences
}

private func getPlist(plistURL: URL) throws -> [String: Any] {
    let data = try Data(contentsOf: plistURL)
    let plist = try PropertyListSerialization.propertyList(
        from: data,
        options: .mutableContainers,
        format: .none)
    return plist as! [String: Any]
}
