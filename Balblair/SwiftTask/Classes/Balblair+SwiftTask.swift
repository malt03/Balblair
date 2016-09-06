//
//  Balblair+SwiftTask.swift
//  Pods
//
//  Created by Koji Murata on 2016/09/06.
//
//

import Alamofire
import SwiftTask

extension Balblair {
  public func createGetTask(path: String, parameters: [String: AnyObject]? = nil, immediately: Bool = true) -> Task<NSProgress, AnyObject?, ErrorType> {
    return Task<NSProgress, AnyObject?, ErrorType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      self.get(path, parameters: parameters, progress: progress, success: fulfill, failure: { reject($1) })
    }
  }
  
  public func createPostTask(path: String, parameters: [String: AnyObject]? = nil, immediately: Bool = true) -> Task<NSProgress, AnyObject?, ErrorType> {
    return Task<NSProgress, AnyObject?, ErrorType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      self.post(path, parameters: parameters, progress: progress, success: fulfill, failure: { reject($1) })
    }
  }
  
  public func createPutTask(path: String, parameters: [String: AnyObject]? = nil, immediately: Bool = true) -> Task<NSProgress, AnyObject?, ErrorType> {
    return Task<NSProgress, AnyObject?, ErrorType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      self.put(path, parameters: parameters, progress: progress, success: fulfill, failure: { reject($1) })
    }
  }
  
  public func createPatchTask(path: String, parameters: [String: AnyObject]? = nil, immediately: Bool = true) -> Task<NSProgress, AnyObject?, ErrorType> {
    return Task<NSProgress, AnyObject?, ErrorType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      self.patch(path, parameters: parameters, progress: progress, success: fulfill, failure: { reject($1) })
    }
  }
  
  public func createDeleteTask(path: String, parameters: [String: AnyObject]? = nil, immediately: Bool = true) -> Task<NSProgress, AnyObject?, ErrorType> {
    return Task<NSProgress, AnyObject?, ErrorType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      self.delete(path, parameters: parameters, progress: progress, success: fulfill, failure: { reject($1) })
    }
  }
  
  public func createUploadTask(
    method: Method = .POST,
    path: String,
    constructingBody: ((MultipartFormData) -> Void),
    immediately: Bool = true) -> Task<NSProgress, AnyObject?, ErrorType>
  {
    return Task<NSProgress, AnyObject?, ErrorType>(paused: !immediately) { (progress, fulfill, reject, configure) in
      var request: Request?
      self.upload(method, path: path, constructingBody: constructingBody, progress: progress, success: fulfill, failure: { reject($1) }, encodingCompletion: { (r) in
        request = r
      })
      configure.cancel = {
        request?.cancel()
      }
    }
  }
}
