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

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    Balblair.defaultConfiguration = Configuration()
    return true
  }
}

class Configuration: BalblairConfiguration {
  let baseUrl = URL(string: "https://qiita.com")!
  var headerBuilder: BalblairHeaderBuilder = HeaderBuilder()
  func apiClientShouldBeginRequest(_ apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?) -> Bool {
    print(path)
    return true
  }
  func apiClientShouldProgress(_ apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?, progress: Progress) -> Bool { return true }
  func apiClientShouldSuccess(_ apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?, result: AnyObject?) -> Error? { return nil }
  func apiClientShouldFailure(_ apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?, result: AnyObject?, error: Error) -> Bool { return true }
}

class HeaderBuilder: BalblairHeaderBuilder {
  func build() -> [String : String] {
    return [:]
  }
}
