# APExtensions

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/APExtensions.svg?style=flat)](http://cocoapods.org/pods/APExtensions)
[![License](https://img.shields.io/cocoapods/l/APExtensions.svg?style=flat)](http://cocoapods.org/pods/APExtensions)
[![Platform](https://img.shields.io/cocoapods/p/APExtensions.svg?style=flat)](http://cocoapods.org/pods/APExtensions)
[![CI Status](http://img.shields.io/travis/APUtils/APExtensions.svg?style=flat)](https://travis-ci.org/APUtils/APExtensions)

A helpful collection of extensions, controllers and protocols

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

#### Carthage

Please check [official guide](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos)

Cartfile:

```
github "APUtils/APExtensions"
```

#### CocoaPods

APExtensions is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'APExtensions'
```

Available subspecs: `Core`, `ViewState`, `Storyboard`. Example Podfile for subspec:

```ruby
pod 'APExtensions/Core'
pod 'APExtensions/ViewState'
pod 'APExtensions/Storyboard'
```

## Usage

See [documentation](http://cocoadocs.org/docsets/APExtensions) for more details.

### Core

TODO

### Abstractions

Various abstractions that simplyfies working.

#### DelayedValue

Simple abstraction that simplifies working with values that needs some time to be fetched. Kind of promise. Good to use in view models to simplify view configuration.

```swift
DelayedValue<UIImage> { completion in
    // Getting image async. It takes some time.
    
    // Return image
    completion(image)
}.onValueAvailable { image in
    // Will be called when image is available
    self.imageView.image = image
}
```

### ViewState

#### ViewController

- Extends UIViewController with .viewState enum property. Possible cases: `.notLoaded`, `.didLoad`, `.willAppear`, `.didAppear`, `.willDisappear`, `.didDisappear`.
- Every UIViewController starts to send notifications about its state change. Available notifications to observe: `.UIViewControllerWillMoveToParentViewController`, `.UIViewControllerViewDidLoad`, `.UIViewControllerViewWillAppear`, `.UIViewControllerViewDidAppear`, `.UIViewControllerViewWillDisappear`, `.UIViewControllerViewDidDisappear`. You could check `userInfo` notification's dictionary for parameters if needed.
- Adds `.hideKeyboardOnTouch` @IBInspectable property to hide keyboard on touch outside.

#### View

Adds `.becomeFirstResponderOnViewDidAppear` @IBInspectable property to become first responser on `viewDidAppear`.

### Storyboard

Extends default attributes that can be configured using storyboard.


**NSLayoutConstraint**:

<img src="Example/APExtensions/nslayoutconstraint.png"/>

- `fitScreenSize` to adjust constraint constant according to screen size. [*](https://github.com/APUtils/APExtensions#remark)
- `onePixelSize` to make constraint 1 pixel size

**UIButton**:

<img src="Example/APExtensions/uibutton.png"/>

- `fitScreenSize` to adjust font size according to screen size. [*](https://github.com/APUtils/APExtensions#remark)
- `lines` to change title label max lines count

**UIImageView**:

<img src="Example/APExtensions/UIImageView.png"/>

- `fitScreenSize` to adjust image size according to screen size. [*](https://github.com/APUtils/APExtensions#remark)
- `localizableImageName` to use localize specific image. You name your images like `image_en`, `image_ru`, `image_fr` put `image` in `localizableImageName` field and assure you localized `_en` to be `_fr` for French localization, `_ru` for Russian and so on.

**UILabel**:

<img src="Example/APExtensions/UILabel.png"/>

- `fitScreenSize` to adjust font size according to screen size. [*](https://github.com/APUtils/APExtensions#remark)

**UIScrollView**:

<img src="Example/APExtensions/UIScrollView.png"/>

- `avoidTopBars` to set contentInset.top to 64
- `avoidTabBar` to set contentInset.bottom to 49

**UITextView**:

<img src="Example/APExtensions/UITextView.png"/>

- `fitScreenSize` to adjust font size according to screen size. [*](https://github.com/APUtils/APExtensions#remark)

**UIView**:

<img src="Example/APExtensions/uiview.png"/>

- `borderColor` to set border color
- `borderWidth` to set border width
- `borderOnePixelWidth` to make border 1 pixel width
- `cornerRadius` to set corners radius
- `shadowColor` to set shadow color
- `shadowOffset` to set shadow offset
- `shadowOpacity` to set shadow opacity
- `shadowRadius` to set shadow radius
- `shadowApplyPath` to apply view bounds rect as shadow pass. Greatly improves performance for opaque views.

**UIViewController**:

<img src="Example/APExtensions/UIViewController.png"/>

- `hideKeyboardOnTouch` to hide keyboard on touch outside it

#### Remark

Assuming layout was made for highest screen size (iPhone 6+, 6s+, 7+) so subject will be reduced propotionally on lower resolution screens.

## Contributions

Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.

## Author

Anton Plebanovich, anton.plebanovich@gmail.com

## License

APExtensions is available under the MIT license. See the LICENSE file for more info.
