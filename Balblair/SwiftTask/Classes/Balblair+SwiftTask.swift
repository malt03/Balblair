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
  public func createGetTask(path: String, parameters: [String: Any]? = nil, immediately: Bool = true) -> Task<Progress, Any?, Error> {
    return Task<Progress, Any?, Error>(paused: !immediately) { (progress, fulfill, reject, configure) in
      self.get(path: path, parameters: parameters, progress: progress, success: fulfill, failure: { reject($1) })
    }
  }
  
  public func createPostTask(path: String, parameters: [String: Any]? = nil, immediately: Bool = true) -> Task<Progress, Any?, Error> {
    return Task<Progress, Any?, Error>(paused: !immediately) { (progress, fulfill, reject, configure) in
      self.post(path: path, parameters: parameters, progress: progress, success: fulfill, failure: { reject($1) })
    }
  }
  
  public func createPutTask(path: String, parameters: [String: Any]? = nil, immediately: Bool = true) -> Task<Progress, Any?, Error> {
    return Task<Progress, Any?, Error>(paused: !immediately) { (progress, fulfill, reject, configure) in
      self.put(path: path, parameters: parameters, progress: progress, success: fulfill, failure: { reject($1) })
    }
  }
  
  public func createPatchTask(path: String, parameters: [String: Any]? = nil, immediately: Bool = true) -> Task<Progress, Any?, Error> {
    return Task<Progress, Any?, Error>(paused: !immediately) { (progress, fulfill, reject, configure) in
      self.patch(path: path, parameters: parameters, progress: progress, success: fulfill, failure: { reject($1) })
    }
  }
  
  public func createDeleteTask(path: String, parameters: [String: Any]? = nil, immediately: Bool = true) -> Task<Progress, Any?, Error> {
    return Task<Progress, Any?, Error>(paused: !immediately) { (progress, fulfill, reject, configure) in
      self.delete(path: path, parameters: parameters, progress: progress, success: fulfill, failure: { reject($1) })
    }
  }
  
  public func createUploadTask(
    method: Method = .post,
    path: String,
    uploadData: [UploadData],
    immediately: Bool = true) -> Task<Progress, Any?, Error>
  {
    return Task<Progress, Any?, Error>(paused: !immediately) { (progress, fulfill, reject, configure) in
      var request: Request?
      self.upload(method: method, path: path, uploadData: uploadData, progress: progress, success: fulfill, failure: { reject($1) }, encodingCompletion: { (r) in
        request = r
      })
      configure.cancel = {
        request?.cancel()
      }
    }
  }
}
