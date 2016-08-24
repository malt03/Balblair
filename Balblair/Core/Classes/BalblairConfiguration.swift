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
  var headerBuilder: BalblairHeaderBuilder { get }
  
  func apiClientShouldBeginRequest(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?) -> Bool
  func apiClientShouldProgress(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?, progress: NSProgress) -> Bool
  func apiClientShouldSuccess(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?, result: AnyObject?) -> ErrorType?
  func apiClientShouldFailure(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?, result: AnyObject?, error: ErrorType) -> Bool
}

extension BalblairConfiguration {
  public func apiClientShouldBeginRequest(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?) -> Bool { return true }
  public func apiClientShouldProgress(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?, progress: NSProgress) -> Bool { return true }
  public func apiClientShouldSuccess(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?, result: AnyObject?) -> ErrorType? { return nil }
  public func apiClientShouldFailure(apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: AnyObject]?, result: AnyObject?, error: ErrorType) -> Bool { return true }
}

extension Balblair {
  public struct HeaderBuilder: BalblairHeaderBuilder {
    private let header: [String: String]
    
    public func build() -> [String: String] {
      return header
    }
  }
  
  public struct Configuration: BalblairConfiguration {
    public let baseUrl: String
    public let headerBuilder: BalblairHeaderBuilder
    
    public init(baseUrl: String, header: [String: String] = [:]) {
      self.baseUrl = baseUrl
      self.headerBuilder = HeaderBuilder(header: header)
    }
  }
}
