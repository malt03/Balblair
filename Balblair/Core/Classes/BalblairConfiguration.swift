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
  
  func apiClientShouldBeginRequest(_ apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: Any]?, uploadData: [Balblair.UploadData]) -> Bool
  func apiClientShouldProgress(_ apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: Any]?, uploadData: [Balblair.UploadData], progress: Progress) -> Bool
  func apiClientShouldSuccess(_ apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: Any]?, uploadData: [Balblair.UploadData], result: Any?) -> Error?
  func apiClientShouldFailure(_ apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: Any]?, uploadData: [Balblair.UploadData], result: Any?, error: Error) -> Bool
}

extension BalblairConfiguration {
  public func apiClientShouldBeginRequest(_ apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: Any]?, uploadData: [Balblair.UploadData]) -> Bool { return true }
  public func apiClientShouldProgress(_ apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: Any]?, uploadData: [Balblair.UploadData], progress: Progress) -> Bool { return true }
  public func apiClientShouldSuccess(_ apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: Any]?, uploadData: [Balblair.UploadData], result: Any?) -> Error? { return nil }
  public func apiClientShouldFailure(_ apiClient: Balblair, method: Balblair.Method, path: String, parameters: [String: Any]?, uploadData: [Balblair.UploadData], result: Any?, error: Error) -> Bool { return true }
}

extension Balblair {
  public struct HeaderBuilder: BalblairHeaderBuilder {
    fileprivate let header: [String: String]
    
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
