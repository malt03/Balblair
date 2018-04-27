//
//  ApiRequest.swift
//  Pods
//
//  Created by Koji Murata on 2016/08/04.
//
//

import Foundation
import Alamofire

public struct NoValue: Codable {
  public init() {}
}

public protocol ApiRequest {
  associatedtype ResultType
  associatedtype ParametersType
  
  var method: Balblair.Method { get }
  var path: String { get }
  var parameters: ParametersType { get }

  // optional
  associatedtype ErrorModelType: ErrorModelProtocol = DefaultErrorModel
  func willBeginRequest(parameters: ParametersType)
  func didSuccess(result: ResultType)
  func didFailure(error: ErrorModelType)
  var configuration: BalblairConfiguration { get }
}

extension ApiRequest {
  public func willBeginRequest(parameters: ParametersType) {}
  public func didSuccess(result: ResultType) {}
  public func didFailure(error: ErrorModelType) {}
  public var configuration: BalblairConfiguration {
    return Balblair.defaultConfiguration
  }
}

extension ApiRequest where ResultType: Decodable, ParametersType: Encodable {
  @discardableResult
  public func request(progress: Balblair.ProgressCallback? = nil,
    success: ((_ result: ResultType) -> Void)? = nil,
    failure: ((_ errorModel: ErrorModelType) -> Void)? = nil) -> DataRequest
  {
    willBeginRequest(parameters: parameters)
    
    return Balblair(configuration: configuration).request(method: method, path: path, parameters: parameters.dictionary, progress: progress, success: { (result) in
      guard let object = result.flatMap({ try? JSONDecoder().decode(ResultType.self, from: $0) }) else {
        let errorModel = ErrorModelType.create(error: BalblairError.parseError, result: result)
        failure?(errorModel)
        self.didFailure(error: errorModel)
        return
      }
      success?(object)
      self.didSuccess(result: object)
    }, failure: { (result, error) in
      let errorModel = ErrorModelType.create(error: error, result: result)
      failure?(errorModel)
      self.didFailure(error: errorModel)
    })
  }
}

extension ApiRequest where ResultType: Decodable, ParametersType == [String: Any] {
  @discardableResult
  public func request(progress: Balblair.ProgressCallback? = nil,
    success: ((_ result: ResultType) -> Void)? = nil,
    failure: ((_ errorModel: ErrorModelType) -> Void)? = nil) -> Request
  {
    willBeginRequest(parameters: parameters)
    return Balblair(configuration: configuration).request(method: method, path: path, parameters: parameters, progress: progress, success: { (result) in
      guard let object = result.flatMap({ try? JSONDecoder().decode(ResultType.self, from: $0) }) else {
        let errorModel = ErrorModelType.create(error: BalblairError.parseError, result: result)
        failure?(errorModel)
        self.didFailure(error: errorModel)
        return
      }
      success?(object)
      self.didSuccess(result: object)
    }, failure: { (result, error) in
      let errorModel = ErrorModelType.create(error: error, result: result)
      failure?(errorModel)
      self.didFailure(error: errorModel)
    })
  }
}
