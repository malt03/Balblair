//
//  Balblair.swift
//  Pods
//
//  Created by Koji Murata on 2016/08/03.
//
//

import Foundation
import Alamofire

public class Balblair {
  public typealias ProgressCallback = (progress: NSProgress) -> Void
  public typealias SuccessCallback = (result: AnyObject?) -> Void
  public typealias FailureCallback = (result: AnyObject?, error: ErrorType) -> Void
  
  public static var defaultConfiguration = Balblair.Configuration(baseUrl: "http://example.com")
  
  public enum Method {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
    
    var alamofires: Alamofire.Method {
      switch self {
      case .GET:    return .GET
      case .POST:   return .POST
      case .PUT:    return .PUT
      case .PATCH:  return .PATCH
      case .DELETE: return .DELETE
      }
    }
  }
  
  private let configuration: BalblairConfiguration
  
  public convenience init() {
    self.init(configuration: Balblair.defaultConfiguration)
  }
  
  public init(configuration: BalblairConfiguration) {
    self.configuration = configuration
  }
  
  public func get(
    path: String,
    parameters: [String: AnyObject]? = nil,
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil)
  {
    request(.GET, path: path, parameters: parameters, progress: progress, success: success, failure: failure)
  }

  public func post(
    path: String,
    parameters: [String: AnyObject]? = nil,
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil)
  {
    request(.POST, path: path, parameters: parameters, progress: progress, success: success, failure: failure)
  }
  
  public func put(
    path: String,
    parameters: [String: AnyObject]? = nil,
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil)
  {
    request(.PUT, path: path, parameters: parameters, progress: progress, success: success, failure: failure)
  }
  
  public func patch(
    path: String,
    parameters: [String: AnyObject]? = nil,
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil)
  {
    request(.PATCH, path: path, parameters: parameters, progress: progress, success: success, failure: failure)
  }
  
  public func delete(
    path: String,
    parameters: [String: AnyObject]? = nil,
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil)
  {
    request(.DELETE, path: path, parameters: parameters, progress: progress, success: success, failure: failure)
  }
  
  public func request(
    method: Method,
    path: String,
    parameters: [String: AnyObject]? = nil,
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil) -> Request
  {
    let request = Alamofire.request(method.alamofires, configuration.baseUrl + path, parameters: parameters, headers: configuration.header)
    
    if !configuration.apiClientShouldBeginRequest(self, method: method, path: path, parameters: parameters) { return request }

    request.progress { (_, totalBytesWritten, totalBytesExpectedToWrite) in
      let p = NSProgress(totalUnitCount: totalBytesExpectedToWrite)
      p.completedUnitCount = totalBytesWritten
      self.progress(method, path: path, parameters: parameters, progress: p, handler: progress)
    }.validate().responseJSON { (response) in
      let result = response.result
      if let error = result.error {
        self.failure(method, path: path, parameters: parameters, result: result.value, error: error, handler: failure)
        return
      }
      success?(result: response.result.value)
    }
    return request
  }
  
  private func progress(method: Method, path: String, parameters: [String: AnyObject]?, progress: NSProgress, handler: ProgressCallback?) {
    guard let h = handler else { return }
    if configuration.apiClientShouldProgress(self, method: method, path: path, parameters: parameters, progress: progress) {
      h(progress: progress)
    }
  }

  private func success(method: Method, path: String, parameters: [String: AnyObject]?, result: AnyObject?, successHandler: SuccessCallback?, failureHandler: FailureCallback?) {
    if let error = configuration.apiClientShouldSuccess(self, method: method, path: path, parameters: parameters, result: result) {
      failure(method, path: path, parameters: parameters, result: result, error: error, handler: failureHandler)
    } else {
      successHandler?(result: result)
    }
  }

  private func failure(method: Method, path: String, parameters: [String: AnyObject]?, result: AnyObject?, error: ErrorType, handler: FailureCallback?) {
    guard let h = handler else { return }
    if configuration.apiClientShouldFailure(self, method: method, path: path, parameters: parameters, result: result, error: error) {
      h(result: result, error: error)
    }
  }
}
