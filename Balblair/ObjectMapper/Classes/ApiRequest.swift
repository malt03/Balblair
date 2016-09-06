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
  public init?(_ map: Map) {}
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
  public func request(progress
    progress: Balblair.ProgressCallback? = nil,
    success: ((result: ResultType) -> Void)? = nil,
    failure: ((errorModel: ErrorModelType) -> Void)? = nil) -> Request
  {
    return Balblair().request(method, path: path, parameters: parameters.toJSON(), progress: progress, success: { (result) in
      guard let object = Mapper<ResultType>().map(result) else {
        failure?(errorModel: ErrorModelType.create(BalblairError.ParseError, result: result))
        return
      }
      success?(result: object)
    }, failure: { (result, error) in
      failure?(errorModel: ErrorModelType.create(error, result: result))
    })
  }
}

extension ApiRequest where ResultType: _ArrayType, ResultType.Element: Mappable, ParametersType: Mappable {
  public func request(progress
    progress: Balblair.ProgressCallback? = nil,
    success: ((result: ResultType) -> Void)? = nil,
    failure: ((errorModel: ErrorModelType) -> Void)? = nil) -> Request
  {
    return Balblair().request(method, path: path, parameters: parameters.toJSON(), progress: progress, success: { (result) in
      guard let object = Mapper<ResultType.Element>().mapArray(result) as? ResultType else {
        failure?(errorModel: ErrorModelType.create(BalblairError.ParseError, result: result))
        return
      }
      success?(result: object)
    }, failure: { (result, error) in
      failure?(errorModel: ErrorModelType.create(error, result: result))
    })
  }
}

extension ApiRequest where ResultType: Mappable, ParametersType == [String: AnyObject] {
  public func request(progress
    progress: Balblair.ProgressCallback? = nil,
    success: ((result: ResultType) -> Void)? = nil,
    failure: ((errorModel: ErrorModelType) -> Void)? = nil) -> Request
  {
    return Balblair().request(method, path: path, parameters: parameters, progress: progress, success: { (result) in
      guard let object = Mapper<ResultType>().map(result) else {
        failure?(errorModel: ErrorModelType.create(BalblairError.ParseError, result: result))
        return
      }
      success?(result: object)
    }, failure: { (result, error) in
      failure?(errorModel: ErrorModelType.create(error, result: result))
    })
  }
}

extension ApiRequest where ResultType: _ArrayType, ResultType.Element: Mappable, ParametersType == [String: AnyObject] {
  public func request(progress
    progress: Balblair.ProgressCallback? = nil,
    success: ((result: ResultType) -> Void)? = nil,
    failure: ((errorModel: ErrorModelType) -> Void)? = nil) -> Request
  {
    return Balblair().request(method, path: path, parameters: parameters, progress: progress, success: { (result) in
      guard let object = Mapper<ResultType.Element>().mapArray(result) as? ResultType else {
        failure?(errorModel: ErrorModelType.create(BalblairError.ParseError, result: result))
        return
      }
      success?(result: object)
    }, failure: { (result, error) in
      failure?(errorModel: ErrorModelType.create(error, result: result))
    })
  }
}
