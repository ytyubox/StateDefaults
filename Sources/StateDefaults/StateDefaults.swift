import Foundation
@propertyWrapper
public
class StateDefaults<Value>:ObservableObject where Value : Equatable {
    
    
    private var storage: UserDefaults!
    private let key: String
    @Published private var value: Value
    
    public init(
        _ key: String,
        defaultValue: Value,
        userDefaults: UserDefaults? = .standard
    ) {
        self.key = key
        self.storage = userDefaults
        
        defer {
            NotificationCenter.default
                .addObserver(
                    self,
                    selector: #selector(didReciveUpdate),
                    name: UserDefaults.didChangeNotification,
                    object: .none)
        }
        
        if let valueFromStorage = storage.object(forKey: key) as? Value {
            self._value = Published(wrappedValue: valueFromStorage)
            return
        }
        
        self._value = Published(wrappedValue: defaultValue)
        storage.set(defaultValue, forKey: key)
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
}
