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
  
  var method: Balblair.Method { get }
  var path: String { get }
  var parameters: ParametersType { get }
}

extension ApiRequest where ResultType: Mappable, ParametersType: Mappable {
  public func request(progress: Balblair.ProgressCallback? = nil,
    success: ((_ result: ResultType) -> Void)? = nil,
    failure: ((_ errorModel: ErrorModelType) -> Void)? = nil) -> DataRequest
  {
    return Balblair().request(method: method, path: path, parameters: parameters.toJSON(), progress: progress, success: { (result) in
      guard let object = Mapper<ResultType>().map(JSONObject: result) else {
        failure?(ErrorModelType.create(error: BalblairError.parseError, result: result))
        return
      }
      success?(object)
    }, failure: { (result, error) in
      failure?(ErrorModelType.create(error: error, result: result))
    })
  }
}

extension ApiRequest where ResultType: _ArrayProtocol, ResultType.Element: Mappable, ParametersType: Mappable {
  public func request(progress: Balblair.ProgressCallback? = nil,
    success: ((_ result: ResultType) -> Void)? = nil,
    failure: ((_ errorModel: ErrorModelType) -> Void)? = nil) -> Request
  {
    return Balblair().request(method: method, path: path, parameters: parameters.toJSON(), progress: progress, success: { (result) in
      guard let object = Mapper<ResultType.Element>().mapArray(JSONObject: result) as? ResultType else {
        failure?(ErrorModelType.create(error: BalblairError.parseError, result: result))
        return
      }
      success?(object)
    }, failure: { (result, error) in
      failure?(ErrorModelType.create(error: error, result: result))
    })
  }
}

extension ApiRequest where ResultType: Mappable, ParametersType == [String: Any] {
  public func request(progress: Balblair.ProgressCallback? = nil,
    success: ((_ result: ResultType) -> Void)? = nil,
    failure: ((_ errorModel: ErrorModelType) -> Void)? = nil) -> Request
  {
    return Balblair().request(method: method, path: path, parameters: parameters, progress: progress, success: { (result) in
      guard let object = Mapper<ResultType>().map(JSONObject: result) else {
        failure?(ErrorModelType.create(error: BalblairError.parseError, result: result))
        return
      }
      success?(object)
    }, failure: { (result, error) in
      failure?(ErrorModelType.create(error: error, result: result))
    })
  }
}

extension ApiRequest where ResultType: _ArrayProtocol, ResultType.Element: Mappable, ParametersType == [String: Any] {
  public func request(progress: Balblair.ProgressCallback? = nil,
    success: ((_ result: ResultType) -> Void)? = nil,
    failure: ((_ errorModel: ErrorModelType) -> Void)? = nil) -> Request
  {
    return Balblair().request(method: method, path: path, parameters: parameters, progress: progress, success: { (result) in
      guard let object = Mapper<ResultType.Element>().mapArray(JSONObject: result) as? ResultType else {
        failure?(ErrorModelType.create(error: BalblairError.parseError, result: result))
        return
      }
      success?(object)
    }, failure: { (result, error) in
      failure?(ErrorModelType.create(error: error, result: result))
    })
  }
}
