//
//  AppDelegate.swift
//  ApiClient
//
//  Created by Koji Murata on 08/03/2016.
//  Copyright (c) 2016 Koji Murata. All rights reserved.
//

import UIKit
import Balblair

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    Balblair.defaultConfiguration = Configuration()
    return true
  }
}

class Configuration: BalblairConfiguration {
  let baseUrl = "https://qiita.com/"
  var headerBuilder: BalblairHeaderBuilder = HeaderBuilder()
}

class HeaderBuilder: BalblairHeaderBuilder {
  func build() -> [String : String] {
    return [:]
  }
}
