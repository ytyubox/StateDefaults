import SwiftUI
/// A property wrapper type that can read and write a value from UserDefaults.standard.
fileprivate var defaultKeys =  [UserDefaults:Set<String>]()

public final class Defaults {
  internal init(key: String, userDefaults: UserDefaults) {
    self.key = key
    self.userDefaults = userDefaults
  }
  
  let key:String
  let userDefaults:UserDefaults
  deinit {
    defaultKeys[userDefaults]?.remove(key)
  }
}
@propertyWrapper
public
struct StateDefaults<T>:DynamicProperty {
  let defaults: Defaults
  var defaultValue: State<T>
  
  public init(_ key: String, defaultValue: T, userDefaults: UserDefaults? = .standard) {
    let userDefaults = userDefaults ?? .standard
    var allKeys = defaultKeys[userDefaults] ?? []
    precondition(!allKeys.contains(key),
                 "[StateDefault] key: \(key) is already a property somewhere in you code. Place make sure you have only one")
    self.defaults = Defaults(key: key, userDefaults: userDefaults)
    allKeys.insert(key)
    defaultKeys[userDefaults] = allKeys
    let it = userDefaults.object(forKey: key) as? T ?? defaultValue
    self.defaultValue = State<T>(initialValue: it)
  }
  
  public var wrappedValue: T {
    get {
      return defaultValue.wrappedValue
    }
    nonmutating set {
      process(newValue)
      defaults.userDefaults.set(newValue, forKey: defaults.key)
    }
  }
  
  private nonmutating func process(_ value:T) {
    self.defaultValue.wrappedValue = value
  }
}

/// StateDefaults targetting UserDefaults, replacable.
