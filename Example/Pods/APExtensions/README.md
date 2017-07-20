# APExtensions

[![CI Status](http://img.shields.io/travis/anton-plebanovich/APExtensions.svg?style=flat)](https://travis-ci.org/anton-plebanovich/APExtensions)
[![Version](https://img.shields.io/cocoapods/v/APExtensions.svg?style=flat)](http://cocoapods.org/pods/APExtensions)
[![License](https://img.shields.io/cocoapods/l/APExtensions.svg?style=flat)](http://cocoapods.org/pods/APExtensions)
[![Platform](https://img.shields.io/cocoapods/p/APExtensions.svg?style=flat)](http://cocoapods.org/pods/APExtensions)

TODO

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## GIF animation

TODO

## Installation

#### CocoaPods

APExtensions is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'APExtensions'
```

## Usage

Call `Extensions.prepare()` before any extentions is used. Usually in application delegate method `didFinishLaunchingWithOptions`:

```
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        APExtensions.prepare()
        
        return true
    }
```

See example project for more details.

## Contributions

Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.

## Author

Anton Plebanovich, anton.plebanovich@gmail.com

## License

APExtensions is available under the MIT license. See the LICENSE file for more info.
