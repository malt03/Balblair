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

public struct NoParamsModel: Mappable {
  public init() {}
  public init?(_ map: Map) {}
  mutating public func mapping(map: Map) {}
}

public protocol ApiRequest {
  associatedtype ResultType
  associatedtype ParametersType
  
  var method: Balblair.Method { get }
  var path: String { get }
  var parameters: ParametersType { get }
}

extension ApiRequest where ResultType: Mappable, ParametersType: Mappable {
  public func request(progress
    progress: Balblair.ProgressCallback? = nil,
    success: ((result: ResultType) -> Void)? = nil,
    failure: Balblair.FailureCallback? = nil) -> Request
  {
    return Balblair().request(method, path: path, parameters: parameters.toJSON(), progress: progress, success: { (result) in
      guard let object = Mapper<ResultType>().map(result) else {
        let error = NSError(domain: "malt.balblair", code: -1, userInfo: [
          NSLocalizedDescriptionKey: NSLocalizedString("Parse error", comment: ""),
          NSLocalizedFailureReasonErrorKey: NSLocalizedString("Parse error", comment: ""),
          ])
        failure?(result: result, error: error)
        return
      }
      success?(result: object)
      }, failure: failure)
  }
}

extension ApiRequest where ResultType: _ArrayType, ResultType.Element: Mappable, ParametersType: Mappable {
  public func request(progress
    progress: Balblair.ProgressCallback? = nil,
    success: ((result: ResultType) -> Void)? = nil,
    failure: Balblair.FailureCallback? = nil) -> Request
  {
    return Balblair().request(method, path: path, parameters: parameters.toJSON(), progress: progress, success: { (result) in
      guard let object = Mapper<ResultType.Element>().mapArray(result) as? ResultType else {
        let error = NSError(domain: "malt.balblair", code: -1, userInfo: [
          NSLocalizedDescriptionKey: NSLocalizedString("Parse error", comment: ""),
          NSLocalizedFailureReasonErrorKey: NSLocalizedString("Parse error", comment: ""),
          ])
        failure?(result: result, error: error)
        return
      }
      success?(result: object)
      }, failure: failure)
  }
}

extension ApiRequest where ResultType: Mappable, ParametersType == [String: AnyObject] {
  public func request(progress
    progress: Balblair.ProgressCallback? = nil,
    success: ((result: ResultType) -> Void)? = nil,
    failure: Balblair.FailureCallback? = nil) -> Request
  {
    return Balblair().request(method, path: path, parameters: parameters, progress: progress, success: { (result) in
      guard let object = Mapper<ResultType>().map(result) else {
        let error = NSError(domain: "malt.balblair", code: -1, userInfo: [
          NSLocalizedDescriptionKey: NSLocalizedString("Parse error", comment: ""),
          NSLocalizedFailureReasonErrorKey: NSLocalizedString("Parse error", comment: ""),
          ])
        failure?(result: result, error: error)
        return
      }
      success?(result: object)
      }, failure: failure)
  }
}

extension ApiRequest where ResultType: _ArrayType, ResultType.Element: Mappable, ParametersType == [String: AnyObject] {
  public func request(progress
    progress: Balblair.ProgressCallback? = nil,
    success: ((result: ResultType) -> Void)? = nil,
    failure: Balblair.FailureCallback? = nil) -> Request
  {
    return Balblair().request(method, path: path, parameters: parameters, progress: progress, success: { (result) in
      guard let object = Mapper<ResultType.Element>().mapArray(result) as? ResultType else {
        let error = NSError(domain: "malt.balblair", code: -1, userInfo: [
          NSLocalizedDescriptionKey: NSLocalizedString("Parse error", comment: ""),
          NSLocalizedFailureReasonErrorKey: NSLocalizedString("Parse error", comment: ""),
          ])
        failure?(result: result, error: error)
        return
      }
      success?(result: object)
      }, failure: failure)
  }
}
