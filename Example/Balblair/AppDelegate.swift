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
  let baseUrl = URL(string: "https://httpbin.org")!
  var headerBuilder: BalblairHeaderBuilder = HeaderBuilder()
  func apiClientShouldBeginRequest(_ apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String : Any]?, uploadData: [Balblair.UploadData]) -> Bool {
    print(path)
    return true
  }
  func apiClientShouldProgress(_ apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String : Any]?, uploadData: [Balblair.UploadData], progress: Progress) -> Bool { return true }
  func apiClientShouldSuccess(_ apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String : Any]?, uploadData: [Balblair.UploadData], result: Any?) -> Error? {
    print(String(data: (result as! Data), encoding: .utf8)!)
    return nil
  }
  func apiClientShouldFailure(_ apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String : Any]?, uploadData: [Balblair.UploadData], result: Any?, error: Error) -> Bool { return true }
}

class HeaderBuilder: BalblairHeaderBuilder {
  func build() -> [String : String] {
    return [:]
  }
}
