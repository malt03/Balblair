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
  public func createTask(immediately: Bool = true) -> Task<NSProgress, ResultType, ErrorModelType> {
    return Task<NSProgress, ResultType, ErrorModelType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      let request = self.request(progress: progress, success: fulfill, failure: reject)
      configure.cancel = {
        request.cancel()
      }
    }
  }
}

extension ApiRequest where ResultType: _ArrayType, ResultType.Element: Mappable, ParametersType: Mappable {
  public func createTask(immediately: Bool = true) -> Task<NSProgress, ResultType, ErrorModelType> {
    return Task<NSProgress, ResultType, ErrorModelType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      let request = self.request(progress: progress, success: fulfill, failure: reject)
      configure.cancel = {
        request.cancel()
      }
    }
  }
}

extension ApiRequest where ResultType: Mappable, ParametersType == [String: AnyObject] {
  public func createTask(immediately: Bool = true) -> Task<NSProgress, ResultType, ErrorModelType> {
    return Task<NSProgress, ResultType, ErrorModelType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      let request = self.request(progress: progress, success: fulfill, failure: reject)
      configure.cancel = {
        request.cancel()
      }
    }
  }
}

extension ApiRequest where ResultType: _ArrayType, ResultType.Element: Mappable, ParametersType == [String: AnyObject] {
  public func createTask(immediately: Bool = true) -> Task<NSProgress, ResultType, ErrorModelType> {
    return Task<NSProgress, ResultType, ErrorModelType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      let request = self.request(progress: progress, success: fulfill, failure: reject)
      configure.cancel = {
        request.cancel()
      }
    }
  }
}
