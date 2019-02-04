//
//  ApiRequestWithData.swift
//  Pods
//
//  Created by Koji Murata on 2016/10/28.
//
//

import Foundation
import Alamofire

extension ApiRequest {
  private func progressHandler(progress: Balblair.ProgressCallback?) -> Balblair.ProgressCallback {
    return { (p) in
      self.didProgress(progress: p)
      progress?(p)
    }
  }
  
  private func failureHandler(failure: (( _ errorModel: ErrorModelType) -> Void)?) -> ((Data?, Error) -> Void) {
    return { (result, error) in
      let errorModel = ErrorModelType(error: error, result: result, decoder: self.decoder)
      failure?(errorModel)
      self.didFailure(error: errorModel)
    }
  }
}

extension ApiRequest where ResultType: Decodable, ParametersType: Encodable {
  public func request(
    requestCreated: ((_ request: Request) -> Void)? = nil,
    progress: Balblair.ProgressCallback? = nil,
    success: ((_ result: ResultType) -> Void)? = nil,
    failure: ((_ errorModel: ErrorModelType) -> Void)? = nil
  ) {
    willBeginRequest(parameters: parameters)
    switch encodeType {
    case .form:
      requestForm(progress: progress, success: success, failure: failure)
    case .json:
      requestJSON(success: success, failure: failure)
    }
  }
  
  private func requestForm(
    requestCreated: ((_ request: Request) -> Void)? = nil,
    progress: Balblair.ProgressCallback?,
    success: ((_ result: ResultType) -> Void)?,
    failure: ((_ errorModel: ErrorModelType) -> Void)?
  ) {
    Balblair(configuration: configuration).requestForm(
      method: method,
      path: path,
      parameters: parameters.createDictionary(encoder: encoder),
      uploadData: uploadData ?? [],
      progress: progressHandler(progress: progress),
      success: successHandler(success: success, failure: failure),
      failure: failureHandler(failure: failure),
      encodingCompletion: { requestCreated?($0) }
    )
  }
  
  private func requestJSON(
    requestCreated: ((_ request: Request) -> Void)? = nil,
    success: ((_ result: ResultType) -> Void)?,
    failure: ((_ errorModel: ErrorModelType) -> Void)?
  ) {
    let request = Balblair(configuration: configuration).requestJSON(
      method: method,
      path: path,
      parameters: parameters.createDictionary(encoder: encoder),
      success: successHandler(success: success, failure: failure),
      failure: failureHandler(failure: failure)
    )
    requestCreated?(request)
  }
  
  private func successHandler(success: ((_ result: ResultType) -> Void)?, failure: ((_ errorModel: ErrorModelType) -> Void)?) -> ((Data?) -> Void) {
    return { (result) in
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
    }
  }
  
  
}

extension ApiRequest where ResultType: Decodable, ParametersType == [String: Any] {
  public func request(
    requestCreated: ((_ request: Request) -> Void)? = nil,
    progress: Balblair.ProgressCallback? = nil,
    success: ((_ result: ResultType) -> Void)? = nil,
    failure: ((_ errorModel: ErrorModelType) -> Void)? = nil
  ) {
    willBeginRequest(parameters: parameters)
    switch encodeType {
    case .form:
      requestForm(progress: progress, success: success, failure: failure)
    case .json:
      requestJSON(success: success, failure: failure)
    }
  }
  
  private func requestForm(
    requestCreated: ((_ request: Request) -> Void)? = nil,
    progress: Balblair.ProgressCallback?,
    success: ((_ result: ResultType) -> Void)?,
    failure: ((_ errorModel: ErrorModelType) -> Void)?
  ) {
    Balblair(configuration: configuration).requestForm(
      method: method,
      path: path,
      parameters: parameters,
      uploadData: uploadData ?? [],
      progress: progressHandler(progress: progress),
      success: successHandler(success: success, failure: failure),
      failure: failureHandler(failure: failure),
      encodingCompletion: { requestCreated?($0) }
    )
  }
  
  private func requestJSON(
    requestCreated: ((_ request: Request) -> Void)? = nil,
    success: ((_ result: ResultType) -> Void)?,
    failure: ((_ errorModel: ErrorModelType) -> Void)?
  ) {
    let request = Balblair(configuration: configuration).requestJSON(
      method: method,
      path: path,
      parameters: parameters,
      success: successHandler(success: success, failure: failure),
      failure: failureHandler(failure: failure)
    )
    requestCreated?(request)
  }
  
  private func successHandler(success: ((_ result: ResultType) -> Void)?, failure: ((_ errorModel: ErrorModelType) -> Void)?) -> ((Data?) -> Void) {
    return { (result) in
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
    }
  }
}
