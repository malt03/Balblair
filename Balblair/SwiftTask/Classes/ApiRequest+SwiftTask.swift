//
//  ApiRequest+SwiftTask.swift
//  Pods
//
//  Created by Koji Murata on 2016/09/01.
//
//

import Foundation
import Alamofire
import SwiftTask
import ObjectMapper

extension ApiRequest where ResultType: Mappable, ParametersType: Mappable {
  public func createTask(_ immediately: Bool = true) -> Task<Progress, ResultType, ErrorModelType> {
    return Task<Progress, ResultType, ErrorModelType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      let request = self.request(progress: progress, success: fulfill, failure: reject)
      configure.cancel = {
        request.cancel()
      }
    }
  }
}

extension ApiRequest where ResultType: _ArrayProtocol, ResultType.Element: Mappable, ParametersType: Mappable {
  public func createTask(_ immediately: Bool = true) -> Task<Progress, ResultType, ErrorModelType> {
    return Task<Progress, ResultType, ErrorModelType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      let request = self.request(progress: progress, success: fulfill, failure: reject)
      configure.cancel = {
        request.cancel()
      }
    }
  }
}

extension ApiRequest where ResultType: Mappable, ParametersType == [String: Any] {
  public func createTask(_ immediately: Bool = true) -> Task<Progress, ResultType, ErrorModelType> {
    return Task<Progress, ResultType, ErrorModelType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      let request = self.request(progress: progress, success: fulfill, failure: reject)
      configure.cancel = {
        request.cancel()
      }
    }
  }
}

extension ApiRequest where ResultType: _ArrayProtocol, ResultType.Element: Mappable, ParametersType == [String: Any] {
  public func createTask(_ immediately: Bool = true) -> Task<Progress, ResultType, ErrorModelType> {
    return Task<Progress, ResultType, ErrorModelType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      let request = self.request(progress: progress, success: fulfill, failure: reject)
      configure.cancel = {
        request.cancel()
      }
    }
  }
}

extension ApiRequest {
  public typealias TaskType = Task<Progress, ResultType, ErrorModelType>
}
