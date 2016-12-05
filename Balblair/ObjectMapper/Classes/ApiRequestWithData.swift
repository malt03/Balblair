//
//  ApiRequestWithData.swift
//  Pods
//
//  Created by Koji Murata on 2016/10/28.
//
//

import Foundation
import Alamofire
import ObjectMapper

public protocol ApiRequestWithData: ApiRequest {
  var uploadData: [Balblair.UploadData] { get }
}

extension ApiRequestWithData where ResultType: Mappable, ParametersType: Mappable {
  @discardableResult
  public func request(progress: Balblair.ProgressCallback? = nil,
                      success: ((_ result: ResultType) -> Void)? = nil,
                      failure: ((_ errorModel: ErrorModelType) -> Void)? = nil,
                      encodingCompletion: ((_ request: Request) -> Void)? = nil)
  {
    willBeginRequest(parameters: parameters)
    Balblair(configuration: configuration).upload(method: method, path: path, parameters: parameters.toJSON(), uploadData: uploadData, progress: progress, success: { (result) in
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
    }, encodingCompletion: encodingCompletion)
  }
}

extension ApiRequestWithData where ResultType: _ArrayProtocol, ResultType.Element: Mappable, ParametersType: Mappable {
  @discardableResult
  public func request(progress: Balblair.ProgressCallback? = nil,
                      success: ((_ result: ResultType) -> Void)? = nil,
                      failure: ((_ errorModel: ErrorModelType) -> Void)? = nil,
                      encodingCompletion: ((_ request: Request) -> Void)? = nil)
  {
    willBeginRequest(parameters: parameters)
    Balblair(configuration: configuration).upload(method: method, path: path, parameters: parameters.toJSON(), uploadData: uploadData, progress: progress, success: { (result) in
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
    }, encodingCompletion: encodingCompletion)
  }
}

extension ApiRequestWithData where ResultType: Mappable, ParametersType == [String: Any] {
  @discardableResult
  public func request(progress: Balblair.ProgressCallback? = nil,
                      success: ((_ result: ResultType) -> Void)? = nil,
                      failure: ((_ errorModel: ErrorModelType) -> Void)? = nil,
                      encodingCompletion: ((_ request: Request) -> Void)? = nil)
  {
    willBeginRequest(parameters: parameters)
    Balblair(configuration: configuration).upload(method: method, path: path, parameters: parameters, uploadData: uploadData, progress: progress, success: { (result) in
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
    }, encodingCompletion: encodingCompletion)
  }
}

extension ApiRequestWithData where ResultType: _ArrayProtocol, ResultType.Element: Mappable, ParametersType == [String: Any] {
  @discardableResult
  public func request(progress: Balblair.ProgressCallback? = nil,
                      success: ((_ result: ResultType) -> Void)? = nil,
                      failure: ((_ errorModel: ErrorModelType) -> Void)? = nil,
                      encodingCompletion: ((_ request: Request) -> Void)? = nil)
  {
    willBeginRequest(parameters: parameters)
    Balblair(configuration: configuration).upload(method: method, path: path, parameters: parameters, uploadData: uploadData, progress: progress, success: { (result) in
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
    }, encodingCompletion: encodingCompletion)
  }
}
