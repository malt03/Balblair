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
  public func createTask(immediately: Bool = true) -> Task<NSProgress, ResultType, ErrorType> {
    return Task<NSProgress, ResultType, ErrorType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      let request = self.request(progress: progress, success: fulfill, failure: { reject($1) })
      configure.cancel = {
        request.cancel()
      }
    }
  }
}

extension ApiRequest where ResultType: _ArrayType, ResultType.Element: Mappable, ParametersType: Mappable {
  public func createTask(immediately: Bool = true) -> Task<NSProgress, ResultType, ErrorType> {
    return Task<NSProgress, ResultType, ErrorType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      let request = self.request(progress: progress, success: fulfill, failure: { reject($1) })
      configure.cancel = {
        request.cancel()
      }
    }
  }
}

extension ApiRequest where ResultType: Mappable, ParametersType == [String: AnyObject] {
  public func createTask(immediately: Bool = true) -> Task<NSProgress, ResultType, ErrorType> {
    return Task<NSProgress, ResultType, ErrorType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      let request = self.request(progress: progress, success: fulfill, failure: { reject($1) })
      configure.cancel = {
        request.cancel()
      }
    }
  }
}

extension ApiRequest where ResultType: _ArrayType, ResultType.Element: Mappable, ParametersType == [String: AnyObject] {
  public func createTask(immediately: Bool = true) -> Task<NSProgress, ResultType, ErrorType> {
    return Task<NSProgress, ResultType, ErrorType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      let request = self.request(progress: progress, success: fulfill, failure: { reject($1) })
      configure.cancel = {
        request.cancel()
      }
    }
  }
}
