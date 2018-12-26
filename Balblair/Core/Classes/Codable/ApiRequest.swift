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
  associatedtype ErrorResultType: Decodable = DefaultErrorResult
  func willBeginRequest(parameters: ParametersType)
  func didSuccess(result: ResultType)
  func didFailure(error: ErrorModelType)
  var configuration: BalblairConfiguration { get }
  var decoder: JSONDecoder { get }
  var encoder: JSONEncoder { get }
  
  typealias ErrorModelType = ErrorModel<ErrorResultType>
}

extension ApiRequest {
  public func willBeginRequest(parameters: ParametersType) {}
  public func didSuccess(result: ResultType) {}
  public func didFailure(error: ErrorModelType) {}
  public var configuration: BalblairConfiguration {
    return Balblair.defaultConfiguration
  }
  public var decoder: JSONDecoder { return JSONDecoder() }
  public var encoder: JSONEncoder { return JSONEncoder() }
}

extension ApiRequest where ResultType: Decodable, ParametersType: Encodable {
  @discardableResult
  public func request(progress: Balblair.ProgressCallback? = nil,
    success: ((_ result: ResultType) -> Void)? = nil,
    failure: ((_ errorModel: ErrorModelType) -> Void)? = nil) -> DataRequest
  {
    willBeginRequest(parameters: parameters)
    return Balblair(configuration: configuration).request(method: method, path: path, parameters: parameters.createDictionary(encoder: encoder), progress: progress, success: { (result) in
      guard var data = result else {
        let errorModel = ErrorModelType(error: BalblairError.unknown, result: result, decoder: self.decoder)
        failure?(errorModel)
        self.didFailure(error: errorModel)
        return
      }
      if data.count == 0 { data = "{}".data(using: .utf8)! }
      do {
        let object = try self.decoder.decode(ResultType.self, from: data)
        success?(object)
        self.didSuccess(result: object)
      } catch {
        let errorModel = ErrorModelType(error: error, result: result, decoder: self.decoder)
        failure?(errorModel)
        self.didFailure(error: errorModel)
      }
    }, failure: { (result, error) in
      let errorModel = ErrorModelType(error: error, result: result, decoder: self.decoder)
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
      guard var data = result else {
        let errorModel = ErrorModelType(error: BalblairError.unknown, result: result, decoder: self.decoder)
        failure?(errorModel)
        self.didFailure(error: errorModel)
        return
      }
      if data.count == 0 { data = "{}".data(using: .utf8)! }
      do {
        let object = try self.decoder.decode(ResultType.self, from: data)
        success?(object)
        self.didSuccess(result: object)
      } catch {
        let errorModel = ErrorModelType(error: error, result: result, decoder: self.decoder)
        failure?(errorModel)
        self.didFailure(error: errorModel)
      }
    }, failure: { (result, error) in
      let errorModel = ErrorModelType(error: error, result: result, decoder: self.decoder)
      failure?(errorModel)
      self.didFailure(error: errorModel)
    })
  }
}
