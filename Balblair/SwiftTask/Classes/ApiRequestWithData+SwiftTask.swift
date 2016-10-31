//
//  ApiRequestWithData+SwiftTask.swift
//  Pods
//
//  Created by Koji Murata on 2016/10/31.
//
//

import Foundation
import Alamofire
import SwiftTask
import ObjectMapper

extension ApiRequestWithData where ResultType: Mappable, ParametersType: Mappable {
  public func createTask(immediately: Bool = true) -> Task<Progress, ResultType, ErrorModelType> {
    return Task<Progress, ResultType, ErrorModelType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      self.request(progress: progress, success: fulfill, failure: reject) { (r) in
        configure.cancel = {
          r.cancel()
        }
      }
    }
  }
}

extension ApiRequestWithData where ResultType: _ArrayProtocol, ResultType.Element: Mappable, ParametersType: Mappable {
  public func createTask(immediately: Bool = true) -> Task<Progress, ResultType, ErrorModelType> {
    return Task<Progress, ResultType, ErrorModelType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      self.request(progress: progress, success: fulfill, failure: reject) { (r) in
        configure.cancel = {
          r.cancel()
        }
      }
    }
  }
}

extension ApiRequestWithData where ResultType: Mappable, ParametersType == [String: Any] {
  public func createTask(immediately: Bool = true) -> Task<Progress, ResultType, ErrorModelType> {
    return Task<Progress, ResultType, ErrorModelType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      self.request(progress: progress, success: fulfill, failure: reject) { (r) in
        configure.cancel = {
          r.cancel()
        }
      }
    }
  }
}

extension ApiRequestWithData where ResultType: _ArrayProtocol, ResultType.Element: Mappable, ParametersType == [String: Any] {
  public func createTask(immediately: Bool = true) -> Task<Progress, ResultType, ErrorModelType> {
    return Task<Progress, ResultType, ErrorModelType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      self.request(progress: progress, success: fulfill, failure: reject) { (r) in
        configure.cancel = {
          r.cancel()
        }
      }
    }
  }
}

extension ApiRequestWithData {
  public typealias TaskType = Task<Progress, ResultType, ErrorModelType>
}
