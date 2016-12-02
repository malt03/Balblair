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
  associatedtype ErrorModelType: ErrorModelProtocol = DefaultErrorModel
  associatedtype ParametersType
  
  func handleError(_ error: ErrorModelType)
  
  var method: Balblair.Method { get }
  var path: String { get }
  var parameters: ParametersType { get }
}

extension ApiRequest {
  public func handleError(_ error: ErrorModelType) { }
}

extension ApiRequest where ResultType: Mappable, ParametersType: Mappable {
  @discardableResult
  public func request(progress: Balblair.ProgressCallback? = nil,
    success: ((_ result: ResultType) -> Void)? = nil,
    failure: ((_ errorModel: ErrorModelType) -> Void)? = nil) -> DataRequest
  {
    return Balblair().request(method: method, path: path, parameters: parameters.toJSON(), progress: progress, success: { (result) in
      guard let object = Mapper<ResultType>().map(JSONObject: result) else {
        let errorModel = ErrorModelType.create(error: BalblairError.parseError, result: result)
        self.handleError(errorModel)
        failure?(errorModel)
        return
      }
      success?(object)
    }, failure: { (result, error) in
      let errorModel = ErrorModelType.create(error: error, result: result)
      self.handleError(errorModel)
      failure?(errorModel)
    })
  }
}

extension ApiRequest where ResultType: _ArrayProtocol, ResultType.Element: Mappable, ParametersType: Mappable {
  @discardableResult
  public func request(progress: Balblair.ProgressCallback? = nil,
    success: ((_ result: ResultType) -> Void)? = nil,
    failure: ((_ errorModel: ErrorModelType) -> Void)? = nil) -> Request
  {
    return Balblair().request(method: method, path: path, parameters: parameters.toJSON(), progress: progress, success: { (result) in
      guard let object = Mapper<ResultType.Element>().mapArray(JSONObject: result) as? ResultType else {
        let errorModel = ErrorModelType.create(error: BalblairError.parseError, result: result)
        self.handleError(errorModel)
        failure?(errorModel)
        return
      }
      success?(object)
    }, failure: { (result, error) in
      let errorModel = ErrorModelType.create(error: error, result: result)
      self.handleError(errorModel)
      failure?(errorModel)
    })
  }
}

extension ApiRequest where ResultType: Mappable, ParametersType == [String: Any] {
  @discardableResult
  public func request(progress: Balblair.ProgressCallback? = nil,
    success: ((_ result: ResultType) -> Void)? = nil,
    failure: ((_ errorModel: ErrorModelType) -> Void)? = nil) -> Request
  {
    return Balblair().request(method: method, path: path, parameters: parameters, progress: progress, success: { (result) in
      guard let object = Mapper<ResultType>().map(JSONObject: result) else {
        let errorModel = ErrorModelType.create(error: BalblairError.parseError, result: result)
        self.handleError(errorModel)
        failure?(errorModel)
        return
      }
      success?(object)
    }, failure: { (result, error) in
      let errorModel = ErrorModelType.create(error: error, result: result)
      self.handleError(errorModel)
      failure?(errorModel)
    })
  }
}

extension ApiRequest where ResultType: _ArrayProtocol, ResultType.Element: Mappable, ParametersType == [String: Any] {
  @discardableResult
  public func request(progress: Balblair.ProgressCallback? = nil,
    success: ((_ result: ResultType) -> Void)? = nil,
    failure: ((_ errorModel: ErrorModelType) -> Void)? = nil) -> Request
  {
    return Balblair().request(method: method, path: path, parameters: parameters, progress: progress, success: { (result) in
      guard let object = Mapper<ResultType.Element>().mapArray(JSONObject: result) as? ResultType else {
        let errorModel = ErrorModelType.create(error: BalblairError.parseError, result: result)
        self.handleError(errorModel)
        failure?(errorModel)
        return
      }
      success?(object)
    }, failure: { (result, error) in
      let errorModel = ErrorModelType.create(error: error, result: result)
      self.handleError(errorModel)
      failure?(errorModel)
    })
  }
}
