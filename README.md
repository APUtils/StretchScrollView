# StretchScrollView

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Version](https://img.shields.io/cocoapods/v/StretchScrollView.svg?style=flat)](http://cocoapods.org/pods/StretchScrollView)
[![License](https://img.shields.io/cocoapods/l/StretchScrollView.svg?style=flat)](http://cocoapods.org/pods/StretchScrollView)
[![Platform](https://img.shields.io/cocoapods/p/StretchScrollView.svg?style=flat)](http://cocoapods.org/pods/StretchScrollView)
[![CI Status](http://img.shields.io/travis/APUtils/StretchScrollView.svg?style=flat)](https://travis-ci.org/APUtils/StretchScrollView)

StretchScrollView provides functionality to enlarge title image and hide overlays when scrolling down. When scrolling up it allows to animate background of navigation bar.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## GIF animation

<img src="Example/StretchScrollView/StretchScrollView.gif"/>

## Installation

#### Carthage

**If you are setting `StretchScrollView` class in storyboard assure module field is also `StretchScrollView`**

<img src="Example/StretchScrollView/customClass.png"/>

Please check [official guide](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos)

Cartfile:

```
github "APUtils/StretchScrollView" ~> 6.0
```

Install command: `carthage bootstrap --use-xcframeworks`

Then add both `StretchScrollView` and `ViewState` frameworks to your project. Remove `APExtensionsViewState` dependency if you previously had it.

#### CocoaPods

StretchScrollView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'StretchScrollView', '~> 6.0'
```

#### Swift Package Manager

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding `StretchScrollView` as a dependency is as easy as adding it to the dependencies value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/APUtils/StretchScrollView.git", .upToNextMajor(from: "6.0.0"))
]
```

## Configuration

Assign `StretchScrollView` class to your UIScrollView in storyboard, **assure module field is also `StretchScrollView`**:

<img src="Example/StretchScrollView/customClass.png"/>

Set needed outlets and options.

<img src="Example/StretchScrollView/outlets.png"/>
<img src="Example/StretchScrollView/options.png"/>

Usually content mode `Aspect Fill` fits well for `UIImageView`:

<img src="Example/StretchScrollView/contentMode.png"/>

Properly setup constraints for `stretchedView`. There are two resize modes available: by top and height constraints and by top and sides constraints.

Example constraints setups:

<img src="Example/StretchScrollView/constraints.png"/>

<img src="Example/StretchScrollView/constraints2.png"/>

For second setup if scroll view is enlarged it'll be automatically zoomed at center.

Also works when stretched view is inside `UIStackView` and have height constraint.

```swift
/// StretchScrollView will manage navigation bar transparency by itself.
/// You could disable this option to manage it by yourself or to disable navigation bar animations.
@IBInspectable var manageNavigationBarTransparency: Bool = true

/// In case of transparent navigation bar you may specify background color that will appear when you scroll up.
@IBInspectable var navigationBackgroundColor: UIColor = .clear
```

You are done! See example project for more details.

## Contributions

Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.

## Author

Anton Plebanovich, anton.plebanovich@gmail.com

## License

StretchScrollView is available under the MIT license. See the LICENSE file for more info.
