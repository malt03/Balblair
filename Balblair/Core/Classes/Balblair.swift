//
//  Balblair.swift
//  Pods
//
//  Created by Koji Murata on 2016/08/03.
//
//

import Foundation
import Alamofire

open class Balblair {
  public typealias ProgressCallback = (_ progress: Progress) -> Void
  public typealias SuccessCallback = (_ result: Any?) -> Void
  public typealias FailureCallback = (_ result: Any?, _ error: Error) -> Void
  
  open static var defaultConfiguration: BalblairConfiguration = Balblair.Configuration(baseUrl: "http://example.com")
  
  public enum Method {
    case get
    case post
    case put
    case patch
    case delete
    
    var alamofires: HTTPMethod {
      switch self {
      case .get:    return .get
      case .post:   return .post
      case .put:    return .put
      case .patch:  return .patch
      case .delete: return .delete
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
  
  open func get(
    _ path: String,
    parameters: [String: Any]? = nil,
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil)
  {
    request(.get, path: path, parameters: parameters, progress: progress, success: success, failure: failure)
  }

  open func post(
    _ path: String,
    parameters: [String: Any]? = nil,
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil)
  {
    request(.post, path: path, parameters: parameters, progress: progress, success: success, failure: failure)
  }
  
  open func put(
    _ path: String,
    parameters: [String: Any]? = nil,
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil)
  {
    request(.put, path: path, parameters: parameters, progress: progress, success: success, failure: failure)
  }
  
  open func patch(
    _ path: String,
    parameters: [String: Any]? = nil,
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil)
  {
    request(.patch, path: path, parameters: parameters, progress: progress, success: success, failure: failure)
  }
  
  open func delete(
    _ path: String,
    parameters: [String: Any]? = nil,
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil)
  {
    request(.delete, path: path, parameters: parameters, progress: progress, success: success, failure: failure)
  }
  
  open func upload(
    _ method: Method = .post,
    path: String,
    constructingBody: @escaping ((MultipartFormData) -> Void),
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil,
    encodingCompletion: ((_ request: Request) -> Void)? = nil)
  {
    Alamofire.upload(
      multipartFormData: constructingBody,
      to: configuration.baseUrl + path,
      method: method.alamofires,
      headers: configuration.headerBuilder.build(),
      encodingCompletion: { (encodingResult) in
        switch encodingResult {
        case .success(request: let request, streamingFromDisk: _, streamFileURL: _):
          encodingCompletion?(request)
          self.run(request, method: method, path: path, parameters: nil, progress: progress, success: success, failure: failure)
        case .failure(let error):
          self.failure(method, path: path, parameters: nil, result: nil, error: error, handler: failure)
        }
      }
    )
  }
  
  internal func request(
    _ method: Method,
    path: String,
    parameters: [String: Any]? = nil,
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil) -> DataRequest
  {
    /*
    let request = Alamofire.request(method.alamofires, configuration.baseUrl + path, parameters: parameters, headers: configuration.headerBuilder.build())
    run(request, method: method, path: path, parameters: parameters, progress: progress, success: success, failure: failure)
    return request*/
    let request = Alamofire.request(configuration.baseUrl + path, method: method.alamofires, parameters: parameters, headers: configuration.headerBuilder.build())
    run(request, method: method, path: path, parameters: parameters, progress: progress, success: success, failure: failure)
    return request
  }
  
  private func run(
    _ request: DataRequest,
    method: Method,
    path: String,
    parameters: [String: Any]?,
    progress: ProgressCallback?,
    success: SuccessCallback?,
    failure: FailureCallback?)
  {
    if !configuration.apiClientShouldBeginRequest(self, method: method, path: path, parameters: parameters) { return }
    
    request.downloadProgress { (p) in
      self.progress(method, path: path, parameters: parameters, progress: p, handler: progress)
    }.validate().responseJSON { (response) in
      let result = response.result
      if let error = result.error {
        self.failure(method, path: path, parameters: parameters, result: result.value, error: error, handler: failure)
        return
      }
      self.success(method, path: path, parameters: parameters, result: response.result.value, successHandler: success, failureHandler: failure)
    }
  }
  
  private func progress(_ method: Method, path: String, parameters: [String: Any]?, progress: Progress, handler: ProgressCallback?) {
    guard let h = handler else { return }
    if configuration.apiClientShouldProgress(self, method: method, path: path, parameters: parameters, progress: progress) {
      h(progress)
    }
  }

  private func success(_ method: Method, path: String, parameters: [String: Any]?, result: Any?, successHandler: SuccessCallback?, failureHandler: FailureCallback?) {
    if let error = configuration.apiClientShouldSuccess(self, method: method, path: path, parameters: parameters, result: result) {
      failure(method, path: path, parameters: parameters, result: result, error: error, handler: failureHandler)
    } else {
      successHandler?(result)
    }
  }

  private func failure(_ method: Method, path: String, parameters: [String: Any]?, result: Any?, error: Error, handler: FailureCallback?) {
    guard let h = handler else { return }
    if configuration.apiClientShouldFailure(self, method: method, path: path, parameters: parameters, result: result, error: error) {
      h(result, error)
    }
  }
}
