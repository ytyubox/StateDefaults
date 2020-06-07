import Foundation
@propertyWrapper
public
class StateDefaults<Value>:ObservableObject {

    
    private var storage: UserDefaults
    private let key: String
    private let defaultValue: Value
    
    public init(
        _ key: String,
        defaultValue: Value,
        userDefaults: UserDefaults? = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = userDefaults ?? .standard
        if storage.object(forKey: key) as? Value == nil {
            storage.set(defaultValue, forKey: key)
        }
    }
    
    public var wrappedValue: Value {
        get {
            storage.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            storage.set(newValue, forKey: key)
        }
    }
}
