# StretchScrollView

[![CI Status](http://img.shields.io/travis/anton-plebanovich/StretchScrollView.svg?style=flat)](https://travis-ci.org/anton-plebanovich/StretchScrollView)
[![Version](https://img.shields.io/cocoapods/v/StretchScrollView.svg?style=flat)](http://cocoapods.org/pods/StretchScrollView)
[![License](https://img.shields.io/cocoapods/l/StretchScrollView.svg?style=flat)](http://cocoapods.org/pods/StretchScrollView)
[![Platform](https://img.shields.io/cocoapods/p/StretchScrollView.svg?style=flat)](http://cocoapods.org/pods/StretchScrollView)

StretchScrollView provides functionality to enlarge title image and hide overlays when scrolling down. When scrolling up it allows to animate background of navigation bar.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## GIF animation

<img src="Example/StretchScrollView/StretchScrollView.gif"/>

## Installation

#### CocoaPods

StretchScrollView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'StretchScrollView'
```

## Usage

Assign `StretchScrollView` class to your UIScrollView in storyboard.

<img src="Example/StretchScrollView/customClass.png"/>

Set needed outlets and options.

<img src="Example/StretchScrollView/outlets.png"/>
<img src="Example/StretchScrollView/options.png"/>

You are done!

Please note that you have to make your navigation bar fully transparent if you want to change it's background color. See example project for more details.

## Contributions

Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.

## Author

Anton Plebanovich, anton.plebanovich@gmail.com

## License

StretchScrollView is available under the MIT license. See the LICENSE file for more info.
