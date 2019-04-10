# Endless

Endless is a lighweight endless page indicator based on UICollectionView and CAShapeLayers.

![Endless: Airbnb or Instragram like Page Indicator](https://github.com/SebastianBoldt/Endless/blob/master/Github/banner.png?raw=true)

<a href="https://paypal.me/boldtsebastian"><img src="https://img.shields.io/badge/paypal-donate-blue.svg?longCache=true&style=flat-square" alt="current version" /></a>
<a href="https://cocoapods.org/pods/Jelly"><img src="https://img.shields.io/badge/version-0.0.1-green.svg?longCache=true&style=flat-square" alt="current version" /></a>
<a href="http://twitter.com/sebastianboldt"><img src="https://img.shields.io/badge/twitter-@sebastianboldt-blue.svg?longCache=true&style=flat-square" alt="twitter handle" /></a>
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift4.2-compatible-orange.svg?longCache=true&style=flat-square" alt="Swift 4.2 compatible" /></a>
<a href="https://www.apple.com/de/ios/ios-12/"><img src="https://img.shields.io/badge/platform-iOS-lightgray.svg?longCache=true&style=flat-square" alt="platform" /></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/carthage-compatible-green.svg?longCache=true&style=flat-square" alt="carthage support" /></a>
<a href="https://en.wikipedia.org/wiki/MIT_License"><img src="https://img.shields.io/badge/license-MIT-lightgray.svg?longCache=true&style=flat-square" alt="license" /></a>

## How to use
<p align="center">
    <img src="https://github.com/SebastianBoldt/Endless/blob/master/Github/indicator.gif?raw=true" width="400";
</p>


Create an Endless-Indicator in your storyboard or code without a width  or height constraint.
'Endless' will calculate its intrinsic size at runtime for you. You just need to set the origin.

```swift
class ViewController: UIViewController {
    @IBOutlet weak private var indicator: Endless.Indicator!

    override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = Endless.Configuration(numberOfDots: 20,
                                                  maxNumberOfDots: .seven,
                                                  selectedDotColor: .darkGray,
                                                  unselectedDotColor: .lightGray,
                                                  dotSize: 10,
                                                  spacing: 10)
        indicator?.setup(with: configuration)
    }
}
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

Endless is available through CocoaPods. To install it, simply add the following line to your Podfile:

```ruby
pod 'Endless'
```

## Author

Sebastian Boldt 

www.sebastianboldt.com

## License

Endless is available under the MIT license. See the LICENSE file for more info.
