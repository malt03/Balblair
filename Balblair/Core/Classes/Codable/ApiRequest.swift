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

public enum EncodeType {
  case form
  case json
}

public protocol ApiRequest {
  associatedtype ResultType
  associatedtype ParametersType
  
  var method: Balblair.Method { get }
  var path: String { get }
  var parameters: ParametersType { get }

  // optional
  var uploadData: [Balblair.UploadData] { get }
  var encodeType: EncodeType { get }

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
  public var uploadData: [Balblair.UploadData] { return [] }
  public var encodeType: EncodeType { return .form }
  
  public func willBeginRequest(parameters: ParametersType) {}
  public func didSuccess(result: ResultType) {}
  public func didFailure(error: ErrorModelType) {}
  public var configuration: BalblairConfiguration {
    return Balblair.defaultConfiguration
  }
  public var decoder: JSONDecoder { return JSONDecoder() }
  public var encoder: JSONEncoder { return JSONEncoder() }
}
