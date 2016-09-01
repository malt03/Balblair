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
  func apiClientShouldBeginRequest(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?) -> Bool {
    print(path)
    return true
  }
  func apiClientShouldProgress(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?, progress: NSProgress) -> Bool { return true }
  func apiClientShouldSuccess(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?, result: AnyObject?) -> ErrorType? { return nil }
  func apiClientShouldFailure(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?, result: AnyObject?, error: ErrorType) -> Bool { return true }
}

class HeaderBuilder: BalblairHeaderBuilder {
  func build() -> [String : String] {
    return [:]
  }
}
