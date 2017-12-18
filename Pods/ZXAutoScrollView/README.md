# ZXAutoScrollView

[![CI Status](http://img.shields.io/travis/iFallen/ZXAutoScrollView.svg?style=flat)](https://travis-ci.org/iFallen/ZXAutoScrollView)
[![Version](https://img.shields.io/cocoapods/v/ZXAutoScrollView.svg?style=flat)](http://cocoapods.org/pods/ZXAutoScrollView)
[![License](https://img.shields.io/cocoapods/l/ZXAutoScrollView.svg?style=flat)](http://cocoapods.org/pods/ZXAutoScrollView)
[![Platform](https://img.shields.io/cocoapods/p/ZXAutoScrollView.svg?style=flat)](http://cocoapods.org/pods/ZXAutoScrollView)

## DataSource

```
func numberofPages(_ inScrollView: ZXAutoScrollView) -> Int {
    return dataCount
}
    
func zxAutoScrollView(_ scrollView: ZXAutoScrollView, pageAt index: Int) -> UIView {
    let view = UILabel()
    view.font = UIFont.boldSystemFont(ofSize: 20)    
    view.textColor = UIColor.white
    view.text = "\(index + 1)"
    return view
}
```

## Delegate

```
func zxAutoScrolView(_ scrollView: ZXAutoScrollView, selectAt index: Int) {
    print(index)
}
```


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

>
![DEMO](https://github.com/iFallen/ZXAutoScrollView/raw/master/ScreenShot/Demo.gif)

## Requirements

iOS8 or Later

## Installation

ZXAutoScrollView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZXAutoScrollView'
```

## Author

JuanFelix, <hulj1204@yahoo.com>

## License

ZXAutoScrollView is available under the MIT license. See the LICENSE file for more info.
