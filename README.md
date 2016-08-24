# Balblair

[![CI Status](http://img.shields.io/travis/malt03/Balblair.svg?style=flat)](https://travis-ci.org/malt03/Balblair)
[![Platform](https://img.shields.io/cocoapods/p/Balblair.svg?style=flat)](http://cocoapods.org/pods/Balblair)
![Language](https://img.shields.io/badge/language-Swift%202.2-orange.svg)
[![CocoaPods](https://img.shields.io/cocoapods/v/Balblair.svg?style=flat)](http://cocoapods.org/pods/Balblair)
![License](https://img.shields.io/github/license/malt03/Balblair.svg?style=flat)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

### Initialize

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
  Balblair.defaultConfiguration = Balblair.Configuration(baseUrl: "https://qiita.com/", header: [:])
  return true
}
```

### Create Response Model

```swift
struct QiitaResult: Mappable {
  var title = ""

  init?(_ map: Map) {
    mapping(map)
  }

  mutating func mapping(map: Map) {
    title <- map["title"]
  }
}
```

### Create Request Model

```swift
struct QiitaRequest: ApiRequest {
  typealias ResultType = [Result]

  let method = Balblair.Method.GET
  let path = "api/v2/items"
  let parameters = NoParamsModel()
}
```

### Request

```swift
QiitaRequest().request(progress: { print($0) }, success: { print($0) }, failure: { print($0, $1) })
```

### Request with RxSwift

```swift
_ = QiitaRequest().response.subscribeNext { print($0) }
```

## Installation

Balblair is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Balblair"
```

## Author

Koji Murata, malt.koji@gmail.com

## License

Balblair is available under the MIT license. See the LICENSE file for more info.
