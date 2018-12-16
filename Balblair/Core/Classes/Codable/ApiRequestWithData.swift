//
//  ApiRequestWithData.swift
//  Pods
//
//  Created by Koji Murata on 2016/10/28.
//
//

import Foundation
import Alamofire

public protocol ApiRequestWithData: ApiRequest {
  var uploadData: [Balblair.UploadData] { get }
}

extension ApiRequestWithData where ResultType: Decodable, ParametersType: Encodable {
  
  public func request(progress: Balblair.ProgressCallback? = nil,
                      success: ((_ result: ResultType) -> Void)? = nil,
                      failure: ((_ errorModel: ErrorModelType) -> Void)? = nil,
                      encodingCompletion: ((_ request: Request) -> Void)? = nil)
  {
    willBeginRequest(parameters: parameters)
    Balblair(configuration: configuration).upload(method: method, path: path, parameters: parameters.dictionary, uploadData: uploadData, progress: progress, success: { (result) in
      guard let data = result else {
        let errorModel = ErrorModelType(error: BalblairError.unknown, result: result)
        failure?(errorModel)
        self.didFailure(error: errorModel)
        return
      }
      do {
        let object = try self.jsonDecoder.decode(ResultType.self, from: data)
        success?(object)
        self.didSuccess(result: object)
      } catch {
        let errorModel = ErrorModelType(error: error, result: result)
        failure?(errorModel)
        self.didFailure(error: errorModel)
      }
    }, failure: { (result, error) in
      let errorModel = ErrorModelType(error: error, result: result)
      failure?(errorModel)
      self.didFailure(error: errorModel)
    }, encodingCompletion: encodingCompletion)
  }
}

extension ApiRequestWithData where ResultType: Decodable, ParametersType == [String: Any] {
  public func request(progress: Balblair.ProgressCallback? = nil,
                      success: ((_ result: ResultType) -> Void)? = nil,
                      failure: ((_ errorModel: ErrorModelType) -> Void)? = nil,
                      encodingCompletion: ((_ request: Request) -> Void)? = nil)
  {
    willBeginRequest(parameters: parameters)
    Balblair(configuration: configuration).upload(method: method, path: path, parameters: parameters, uploadData: uploadData, progress: progress, success: { (result) in
      guard let data = result else {
        let errorModel = ErrorModelType(error: BalblairError.unknown, result: result)
        failure?(errorModel)
        self.didFailure(error: errorModel)
        return
      }
      do {
        let object = try self.jsonDecoder.decode(ResultType.self, from: data)
        success?(object)
        self.didSuccess(result: object)
      } catch {
        let errorModel = ErrorModelType(error: error, result: result)
        failure?(errorModel)
        self.didFailure(error: errorModel)
      }
    }, failure: { (result, error) in
      let errorModel = ErrorModelType(error: error, result: result)
      failure?(errorModel)
      self.didFailure(error: errorModel)
    }, encodingCompletion: encodingCompletion)
  }
}
