# StateDefaults
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
AnyStateDefaults.defaults = myUserDefaults
```
## Author

twitter : [@YuTsungYu](https://twitter.com/YuTsungYu) 

## License

MyLibrary is available under the MIT license. See the LICENSE file for more info.

