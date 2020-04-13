import SwiftUI
/// A property wrapper type that can read and write a value from UserDefaults.standard.
fileprivate var _StateDefaults = UserDefaults.standard

@propertyWrapper
public
struct StateDefaults<T>:DynamicProperty {
  let key: String
  var defaultValue: State<T>
  
  public init(_ key: String, defaultValue: T) {
    self.key = key
    let it = Self.defaults.object(forKey: key) as? T ?? defaultValue
    self.defaultValue = State<T>(initialValue: it)
  }
  
  public var wrappedValue: T {
    get {
      return defaultValue.wrappedValue
    }
    nonmutating set {
      process(newValue)
      Self.defaults.set(newValue, forKey: key)
    }
  }
  
  private nonmutating func process(_ value:T) {
    self.defaultValue.wrappedValue = value
  }
}

/// StateDefaults targetting UserDefaults, replacable.
extension StateDefaults {
  public static var defaults:UserDefaults {
    get {
      _StateDefaults
    }
    set {
      _StateDefaults = newValue
    }
  }
}
