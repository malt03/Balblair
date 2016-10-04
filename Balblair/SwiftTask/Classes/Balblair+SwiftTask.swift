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
  public func createGetTask(_ path: String, parameters: [String: Any]? = nil, immediately: Bool = true) -> Task<Progress, Any?, Error> {
    return Task<Progress, Any?, Error>(paused: !immediately) { (progress, fulfill, reject, configure) in
      self.get(path, parameters: parameters, progress: progress, success: fulfill, failure: { reject($1) })
    }
  }
  
  public func createPostTask(_ path: String, parameters: [String: Any]? = nil, immediately: Bool = true) -> Task<Progress, Any?, Error> {
    return Task<Progress, Any?, Error>(paused: !immediately) { (progress, fulfill, reject, configure) in
      self.post(path, parameters: parameters, progress: progress, success: fulfill, failure: { reject($1) })
    }
  }
  
  public func createPutTask(_ path: String, parameters: [String: Any]? = nil, immediately: Bool = true) -> Task<Progress, Any?, Error> {
    return Task<Progress, Any?, Error>(paused: !immediately) { (progress, fulfill, reject, configure) in
      self.put(path, parameters: parameters, progress: progress, success: fulfill, failure: { reject($1) })
    }
  }
  
  public func createPatchTask(_ path: String, parameters: [String: Any]? = nil, immediately: Bool = true) -> Task<Progress, Any?, Error> {
    return Task<Progress, Any?, Error>(paused: !immediately) { (progress, fulfill, reject, configure) in
      self.patch(path, parameters: parameters, progress: progress, success: fulfill, failure: { reject($1) })
    }
  }
  
  public func createDeleteTask(_ path: String, parameters: [String: Any]? = nil, immediately: Bool = true) -> Task<Progress, Any?, Error> {
    return Task<Progress, Any?, Error>(paused: !immediately) { (progress, fulfill, reject, configure) in
      self.delete(path, parameters: parameters, progress: progress, success: fulfill, failure: { reject($1) })
    }
  }
  
  public func createUploadTask(
    _ method: Method = .post,
    path: String,
    constructingBody: @escaping ((MultipartFormData) -> Void),
    immediately: Bool = true) -> Task<Progress, Any?, Error>
  {
    return Task<Progress, Any?, Error>(paused: !immediately) { (progress, fulfill, reject, configure) in
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
