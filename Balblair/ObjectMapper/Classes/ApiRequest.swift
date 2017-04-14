//
//  ApiRequest.swift
//  Pods
//
//  Created by Koji Murata on 2016/08/04.
//
//

import Foundation
import Alamofire
import ObjectMapper

public final class NoParamsModel: Mappable {
  public static let instance = NoParamsModel()

  private init() {}
  public init?(map: Map) {}
  public func mapping(map: Map) {}
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

extension ApiRequest where ResultType: Mappable, ParametersType: Mappable {
  @discardableResult
  public func request(progress: Balblair.ProgressCallback? = nil,
    success: ((_ result: ResultType) -> Void)? = nil,
    failure: ((_ errorModel: ErrorModelType) -> Void)? = nil) -> DataRequest
  {
    willBeginRequest(parameters: parameters)
    return Balblair(configuration: configuration).request(method: method, path: path, parameters: parameters.toJSON(), progress: progress, success: { (result) in
      guard let object = Mapper<ResultType>().map(JSONObject: result) else {
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

extension ApiRequest where ResultType: ExpressibleByArrayLiteral, ResultType.Element: Mappable, ParametersType: Mappable {
  @discardableResult
  public func request(progress: Balblair.ProgressCallback? = nil,
    success: ((_ result: ResultType) -> Void)? = nil,
    failure: ((_ errorModel: ErrorModelType) -> Void)? = nil) -> Request
  {
    willBeginRequest(parameters: parameters)
    return Balblair(configuration: configuration).request(method: method, path: path, parameters: parameters.toJSON(), progress: progress, success: { (result) in
      guard let object = Mapper<ResultType.Element>().mapArray(JSONObject: result) as? ResultType else {
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

extension ApiRequest where ResultType: Mappable, ParametersType == [String: Any] {
  @discardableResult
  public func request(progress: Balblair.ProgressCallback? = nil,
    success: ((_ result: ResultType) -> Void)? = nil,
    failure: ((_ errorModel: ErrorModelType) -> Void)? = nil) -> Request
  {
    willBeginRequest(parameters: parameters)
    return Balblair(configuration: configuration).request(method: method, path: path, parameters: parameters, progress: progress, success: { (result) in
      guard let object = Mapper<ResultType>().map(JSONObject: result) else {
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

extension ApiRequest where ResultType: ExpressibleByArrayLiteral, ResultType.Element: Mappable, ParametersType == [String: Any] {
  @discardableResult
  public func request(progress: Balblair.ProgressCallback? = nil,
    success: ((_ result: ResultType) -> Void)? = nil,
    failure: ((_ errorModel: ErrorModelType) -> Void)? = nil) -> Request
  {
    willBeginRequest(parameters: parameters)
    return Balblair(configuration: configuration).request(method: method, path: path, parameters: parameters, progress: progress, success: { (result) in
      guard let object = Mapper<ResultType.Element>().mapArray(JSONObject: result) as? ResultType else {
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
