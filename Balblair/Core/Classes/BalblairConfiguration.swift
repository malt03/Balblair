//
//  BalblairConfiguration.swift
//  Pods
//
//  Created by Koji Murata on 2016/08/03.
//
//

import Foundation

public protocol BalblairConfiguration {
  var baseUrl: String { get }
  var header: [String: String] { get }
  
  func apiClientShouldBeginRequest(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?) -> Bool
  func apiClientShouldProgress(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?, progress: NSProgress) -> Bool
  func apiClientShouldSuccess(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?, result: AnyObject?) -> ErrorType?
  func apiClientShouldFailure(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?, result: AnyObject?, error: ErrorType) -> Bool
}

extension Balblair {
  public struct Configuration: BalblairConfiguration {
    public let baseUrl: String
    public let header: [String: String]
    
    public init(baseUrl: String, header: [String: String] = [:]) {
      self.baseUrl = baseUrl
      self.header = header
    }
    
    public func apiClientShouldBeginRequest(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?) -> Bool { return true }
    public func apiClientShouldProgress(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?, progress: NSProgress) -> Bool { return true }
    public func apiClientShouldSuccess(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?, result: AnyObject?) -> ErrorType? { return nil }
    public func apiClientShouldFailure(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?, result: AnyObject?, error: ErrorType) -> Bool { return true }
  }
}
