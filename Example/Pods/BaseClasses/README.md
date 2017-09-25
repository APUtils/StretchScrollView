# BaseClasses

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/BaseClasses.svg?style=flat)](http://cocoapods.org/pods/BaseClasses)
[![License](https://img.shields.io/cocoapods/l/BaseClasses.svg?style=flat)](http://cocoapods.org/pods/BaseClasses)
[![Platform](https://img.shields.io/cocoapods/p/BaseClasses.svg?style=flat)](http://cocoapods.org/pods/BaseClasses)
[![CI Status](http://img.shields.io/travis/APUtils/BaseClasses.svg?style=flat)](https://travis-ci.org/APUtils/BaseClasses)

Default configuration for some UI classes through inheritance.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

Please check [official guide](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos)

Cartfile:

```
github "APUtils/BaseClasses"
```

#### CocoaPods

BaseClasses is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BaseClasses'
```

## Usage

See example project for more details.

Just set your class in storyboard and you are done.

<img src="Example/BaseClasses/baseClass.png"/>

Alternatively you could inherit your custom class from BaseClasses class:

```swift
import UIKit
import BaseClasses

class NavigationController: BaseClasses.NavigationController {}
```

#### ScrollView, TableView, CollectionView

Those classes provide decreased button highlight animation

<img src="Example/BaseClasses/ScrollView.gif"/>

#### FullSizeCollectionView

Collection view that resizes it's cells to be the same size as collection view

Example usage together with [StretchScrollView](https://github.com/APUtils/StretchScrollView):

<img src="Example/BaseClasses/FullSizeCollection.gif"/>

#### NavigationBar

Makes touches go through. Useful when it's transparent so user could interact through it.

#### NavigationController

Allows child viewControllers specific status bar configuration. UINavigationController doesn't pay attention to its childs setting. 

Just override `preferredStatusBarStyle` in your custom view controller to configure status bar style for your screen:

```swift
override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
}
```

#### TableViewCell

Preventing backgroud color change for views in selected and highlighted state

<img src="Example/BaseClasses/TableViewCell.gif"/>

#### TextField

TextField with `Done` default button and close keyboard when tap

## Contributions

Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.

## Author

Anton Plebanovich, anton.plebanovich@gmail.com

## License

BaseClasses is available under the MIT license. See the LICENSE file for more info.
