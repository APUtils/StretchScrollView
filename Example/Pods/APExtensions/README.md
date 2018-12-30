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

Cartfile for unified framework:

```
github "APUtils/APExtensions" ~> 5.0
```

Cartfile for separate frameworks:

```
github "APUtils/APExtensions" "abstractions"
github "APUtils/APExtensions" "core"
github "APUtils/APExtensions" "storyboard"
github "APUtils/APExtensions" "view-configuration"
github "APUtils/APExtensions" "view-state"
```

Cartfile for specific commit:
```
github "APUtils/APExtensions" "a01cbc24474822d9b64e70372910f404d6b944a1"
```

#### CocoaPods

APExtensions is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'APExtensions', '~> 5.0'
```

Available subspecs: `Abstractions`,  `Core`, `Storyboard`, `ViewConfiguration`, `ViewState`. Example Podfile for subspec:

```ruby
pod 'APExtensions/Abstractions', '~> 5.0'
pod 'APExtensions/Core', '~> 5.0'
pod 'APExtensions/Storyboard', '~> 5.0'
pod 'APExtensions/ViewConfiguration', '~> 5.0'
pod 'APExtensions/ViewState', '~> 5.0'
```

## Usage

See [documentation](http://cocoadocs.org/docsets/APExtensions) for more details.

### Core

Global Utils and Debug methods, Controllers, Protocols and whole lot of default classes extensions. Read more in [DOCS](https://aputils.github.io/APExtensions/).

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

### ViewConfiguration

Adds `State` enum and `.configure(_:)` method to views so it's easy and robust to configure them.

```swift
// Creating UIImageView.State and store it in view model
let imageViewState: UIImageView.State = .shown(image: UIImage(named: "ic_done_resizeable"))
viewModel.imageViewState = imageViewState

// Configure UIImageView with view model
imageView.configure(viewModel.imageViewState)
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

<img src="https://github.com/APUtils/APExtensions/raw/master/Example/APExtensions/nslayoutconstraint.png"/>

- `fitScreenSize` to adjust constraint constant according to screen size. [*](https://github.com/APUtils/APExtensions#remark)
- `onePixelSize` to make constraint 1 pixel size

**UIButton**:

<img src="https://github.com/APUtils/APExtensions/raw/master/Example/APExtensions/uibutton.png"/>

- `fitScreenSize` to adjust font size according to screen size. [*](https://github.com/APUtils/APExtensions#remark)
- `lines` to change title label max lines count

**UIImageView**:

<img src="https://github.com/APUtils/APExtensions/raw/master/Example/APExtensions/UIImageView.png"/>

- `fitScreenSize` to adjust image size according to screen size. [*](https://github.com/APUtils/APExtensions#remark)
- `localizableImageName` to use localize specific image. You name your images like `image_en`, `image_ru`, `image_fr` put `image` in `localizableImageName` field and assure you localized `_en` to be `_fr` for French localization, `_ru` for Russian and so on.

**UILabel**:

<img src="https://github.com/APUtils/APExtensions/raw/master/Example/APExtensions/UILabel.png"/>

- `fitScreenSize` to adjust font size according to screen size. [*](https://github.com/APUtils/APExtensions#remark)

**UIScrollView**:

<img src="https://github.com/APUtils/APExtensions/raw/master/Example/APExtensions/UIScrollView.png"/>

- `avoidTopBars` to set contentInset.top to 64
- `avoidTabBar` to set contentInset.bottom to 49

**UITextView**:

<img src="https://github.com/APUtils/APExtensions/raw/master/Example/APExtensions/UITextView.png"/>

- `fitScreenSize` to adjust font size according to screen size. [*](https://github.com/APUtils/APExtensions#remark)

**UIView**:

<img src="https://github.com/APUtils/APExtensions/raw/master/Example/APExtensions/uiview.png"/>

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

<img src="https://github.com/APUtils/APExtensions/raw/master/Example/APExtensions/UIViewController.png"/>

- `hideKeyboardOnTouch` to hide keyboard on touch outside it

#### Remark

Assuming layout was made for highest screen size (iPhone 6+, 6s+, 7+) so subject will be reduced propotionally on lower resolution screens.

## Contributions

Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.

## Author

Anton Plebanovich, anton.plebanovich@gmail.com

## License

APExtensions is available under the MIT license. See the LICENSE file for more info.
