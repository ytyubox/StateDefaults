# StateDefaults
![Swift](https://github.com/ytyubox/StateDefaults/workflows/Swift/badge.svg)
![Swift 5.1](https://img.shields.io/badge/Swift-5.1-orange.svg) 
[![SPM](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://github.com/apple/swift-package-manager)

## Usage

```swift
struct ContentView {
  @StateDefaults("key", defaultValue: 0) var tapCount

  var body: some View {
  Button("tap \(tapCount)") {
    self.tapCount += 1
    }
  }
}
```


## Using Custom UserDefaults

```swift
@StateDefaults("key", defaultValue: 0, userDefaults: myuserDefaults) var tapCount
```
## Avoid Duplicate Key
```swift
let p1 = StateDefaults("someKey", defaultValue: 1, userDefaults: defaults)
let p2 = StateDefaults("someKey", defaultValue: 1, userDefaults: defaults)
// precondition  "[StateDefault] key: someKey is already a property somewhere in you code. Place make sure you have only one"
```

However, if the holder of `StateDefaults` can be destroy by arc/stack, it will be fine.
```swift
do {
  _ = StateDefaults("someKey", defaultValue: 1, userDefaults: defaults)
  }
	
  _ = StateDefaults("someKey", defaultValue: 1, userDefaults: defaults)
}
// work fine
```
## Author

twitter : [@YuTsungYu](https://twitter.com/YuTsungYu) 

## License

MyLibrary is available under the MIT license. See the LICENSE file for more info.

