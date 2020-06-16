import Foundation
import Combine

private var _stateDefaultsTarget:UserDefaults = .standard
extension UserDefaults {
    public static var costomStandard:UserDefaults {
        get {
            return _stateDefaultsTarget
        }
        set {
            _stateDefaultsTarget = newValue
        }
    }
}

@propertyWrapper
public
class StateDefaults<Value>: ObservableObject where Value : Equatable
{
    private var storage: UserDefaults!
    private let fileManager = FileManager()
    private let preferencesURL: URL
    private var fileMonitor: FileWriteMonitor?
    private let defaultValue:Value
    private var key:String {
        if let k = _key {return k}
        self._key = _demangleVariableNameFromCallstack()
        return self.key
    }
    internal var _key:String?
    public var projectedValue:StateDefaults<Value> {
        self
    }
    
    public init(
        defaultValue: Value,
        userDefaults: UserDefaults? = .costomStandard)
    {
        self.preferencesURL = getPlistURL(fileManager: fileManager)
        self.storage = userDefaults
        
        defer
        {
            NotificationCenter.default
                .addObserver(
                    self,
                    selector: #selector(didReciveUpdate),
                    name: UserDefaults.didChangeNotification,
                    object: .none)
        }
        
        
        // handle default value

        self.defaultValue = defaultValue
        
        self.fileMonitor = FileWriteMonitor(preferencesURL)
        { [weak self] in
            self?.defaultsPlistChanged()
        }
        
    }
    
    public var wrappedValue: Value
    {
        get
        {
            let key = self.key
            let newValue = storage.value(forKey: key) as? Value ?? defaultValue
            print("get",#function,key,newValue)
            return newValue
        }
     
        set
        {
            objectWillChange.send()
            let key = self.key
            storage.set(newValue, forKey: key)
            print("set",#function,key,newValue)
            some = (1...20).randomElement()!
        }
    }
    
    
    
    @objc private func didReciveUpdate()
    {
//        objectWillChange.send()
    }
    private func defaultsPlistChanged()
    {
        guard
            let plist = try? getPlist(plistURL: preferencesURL),
            let _ = plist[key] as? Value
            else
        {
            return
        }

        objectWillChange.send()

    }
}


// MARK: - Private helper
private func getPlistURL(fileManager: FileManager) -> URL
{
    guard
        let bundleID = Bundle.main.bundleIdentifier,
        let preferences = try? fileManager
            .url(for: .libraryDirectory,
                 in: .userDomainMask,
                 appropriateFor: .none,
                 create: false)
            .appendingPathComponent("Preferences/\(bundleID).plist")
        else
    {
        fatalError("Could not find the preferences folder.")
        
    }
    
    return preferences
}

private func getPlist(plistURL: URL) throws -> [String: Any]
{
    let data = try Data(contentsOf: plistURL)
    let plist = try PropertyListSerialization
        .propertyList(
            from: data,
            options: .mutableContainers,
            format: .none)
    return plist as! [String: Any]
}


// MARK: - KissDefaults
// Idea from https://github.com/lexrus/KissDefault
private
func _demangleVariableNameFromCallstack() -> String {
    let stacks = Thread.callStackSymbols
    //     Since we have the source code, we may guarantee the property name is located in the 3rd symbol
    //     0 KissDefault 0x0000000100001db4 #demangleWrappedName
    //     1 KissDefault 0x0000000100001769 $s11KissDefault0A0V12wrappedValuexvg + 254
    //     2 KissDefault 0x0000000100002efb $s11KissDefault3StrV9staticVarSSvgZ + 235  <- real property
    guard stacks.count > 3 else {
        assertionFailure()
        return ""
    }
    
    let stack = stacks[3]
    
    guard let symbolRange = stack.range(
        of: #"\$s\S+"#,
        options: [.regularExpression, .caseInsensitive]
        ) else {
            assertionFailure()
            return ""
    }
    
    let symbol = String(stack[symbolRange])
    
    return _demangleVariableName(of: symbol)
}
private
func _demangleVariableName(of symbol: String) -> String {
    let ranges = symbol.ranges(of: "[VC]\\d+(?=\\D.*[sSA35])")
    
    let invalidCharacterSet = CharacterSet(charactersIn: " +")
    
    for range in ranges {
        let sub = symbol[range]
        
        guard sub.hasPrefix("V") || sub.hasPrefix("C") else {
            continue
        }
        
        let countStr = sub.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
        
        guard countStr.count > 0, let count = Int(countStr), count > 0 else {
            continue
        }
        
        guard sub.endIndex.utf16Offset(in: symbol) + count <= symbol.count else {
            continue
        }
        
        let variableRange = sub.endIndex ..< symbol.index(sub.endIndex, offsetBy: count)
        let variableName = symbol[variableRange]
        
        if variableName.count == count, variableName.trimmingCharacters(in: invalidCharacterSet).count == count {
            return String(variableName)
        }
    }
    
    // Failover
    return symbol.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
}
private
extension String {
    func ranges(of regEx: String) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        
        while let range = range(
            of: regEx,
            options: .regularExpression,
            range: (ranges.last?.upperBound ?? startIndex)..<endIndex
            ) {
                ranges.append(range)
        }
        return ranges
    }
}
