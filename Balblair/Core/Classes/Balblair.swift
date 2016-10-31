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
  
  public struct UploadData {
    public var data: Data
    public var name: String
    public var fileName: String
    public var mimeType: String
    public init(data: Data, name: String, fileName: String, mimeType: String) {
      self.data = data
      self.name = name
      self.fileName = fileName
      self.mimeType = mimeType
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
    path: String,
    parameters: [String: Any]? = nil,
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil)
  {
    request(method: .get, path: path, parameters: parameters, progress: progress, success: success, failure: failure)
  }

  open func post(
    path: String,
    parameters: [String: Any]? = nil,
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil)
  {
    request(method: .post, path: path, parameters: parameters, progress: progress, success: success, failure: failure)
  }
  
  open func put(
    path: String,
    parameters: [String: Any]? = nil,
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil)
  {
    request(method: .put, path: path, parameters: parameters, progress: progress, success: success, failure: failure)
  }
  
  open func patch(
    path: String,
    parameters: [String: Any]? = nil,
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil)
  {
    request(method: .patch, path: path, parameters: parameters, progress: progress, success: success, failure: failure)
  }
  
  open func delete(
    path: String,
    parameters: [String: Any]? = nil,
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil)
  {
    request(method: .delete, path: path, parameters: parameters, progress: progress, success: success, failure: failure)
  }
  
  open func upload(
    method: Method = .post,
    path: String,
    parameters: [String: Any]? = nil,
    uploadData: [UploadData],
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil,
    encodingCompletion: ((_ request: Request) -> Void)? = nil)
  {
    Alamofire.upload(
      multipartFormData: { (d) in
        uploadData.forEach { d.append($0.data, withName: $0.name, fileName: $0.fileName, mimeType: $0.mimeType) }
        parameters?.forEach {
          guard let data = "\($1)".data(using: .utf8) else { return }
          d.append(data, withName: $0)
        } },
      to: configuration.baseUrl + path,
      method: method.alamofires,
      headers: configuration.headerBuilder.build(),
      encodingCompletion: { (encodingResult) in
        switch encodingResult {
        case .success(request: let request, streamingFromDisk: _, streamFileURL: _):
          encodingCompletion?(request)
          self.run(request: request, method: method, path: path, parameters: parameters, uploadData: uploadData, progress: progress, success: success, failure: failure)
        case .failure(let error):
          self.failure(method: method, path: path, parameters: parameters, uploadData: uploadData, result: nil, error: error, handler: failure)
        }
      }
    )
  }
  
  @discardableResult
  internal func request(
    method: Method,
    path: String,
    parameters: [String: Any]? = nil,
    progress: ProgressCallback? = nil,
    success: SuccessCallback? = nil,
    failure: FailureCallback? = nil) -> DataRequest
  {
    let request = Alamofire.request(configuration.baseUrl + path, method: method.alamofires, parameters: parameters, headers: configuration.headerBuilder.build())
    run(request: request, method: method, path: path, parameters: parameters, uploadData: [], progress: progress, success: success, failure: failure)
    return request
  }
  
  private func run(
    request: DataRequest,
    method: Method,
    path: String,
    parameters: [String: Any]?,
    uploadData: [UploadData],
    progress: ProgressCallback?,
    success: SuccessCallback?,
    failure: FailureCallback?)
  {
    if !configuration.apiClientShouldBeginRequest(self, method: method, path: path, parameters: parameters, uploadData: uploadData) { return }
    
    request.downloadProgress { (p) in
      self.progress(method: method, path: path, parameters: parameters, uploadData: uploadData, progress: p, handler: progress)
    }.validate().responseJSON { (response) in
      let result = response.result
      if let error = result.error {
        self.failure(method: method, path: path, parameters: parameters, uploadData: uploadData, result: result.value, error: error, handler: failure)
        return
      }
      self.success(method: method, path: path, parameters: parameters, uploadData: uploadData, result: response.result.value, successHandler: success, failureHandler: failure)
    }
  }
  
  private func progress(method: Method, path: String, parameters: [String: Any]?, uploadData: [UploadData], progress: Progress, handler: ProgressCallback?) {
    guard let h = handler else { return }
    if configuration.apiClientShouldProgress(self, method: method, path: path, parameters: parameters, uploadData: uploadData, progress: progress) {
      h(progress)
    }
  }

  private func success(method: Method, path: String, parameters: [String: Any]?, uploadData: [UploadData], result: Any?, successHandler: SuccessCallback?, failureHandler: FailureCallback?) {
    if let error = configuration.apiClientShouldSuccess(self, method: method, path: path, parameters: parameters, uploadData: uploadData, result: result) {
      failure(method: method, path: path, parameters: parameters, uploadData: uploadData, result: result, error: error, handler: failureHandler)
    } else {
      successHandler?(result)
    }
  }

  private func failure(method: Method, path: String, parameters: [String: Any]?, uploadData: [UploadData], result: Any?, error: Error, handler: FailureCallback?) {
    guard let h = handler else { return }
    if configuration.apiClientShouldFailure(self, method: method, path: path, parameters: parameters, uploadData: uploadData, result: result, error: error) {
      h(result, error)
    }
  }
}
