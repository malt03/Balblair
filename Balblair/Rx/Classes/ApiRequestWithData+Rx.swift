//
//  ApiRequestWithData+Rx.swift
//  Pods
//
//  Created by Koji Murata on 2016/12/06.
//
//

import Alamofire
import RxSwift

extension ApiRequestWithData where ResultType: Decodable, ParametersType: Encodable {
  public var response: Observable<ResultType> {
    return Observable.create { (observer) -> Disposable in
      var request: Request? = nil
      self.request(success: { (result) in
        observer.onNext(result)
        observer.onCompleted()
      }, failure: { (error) in
        observer.onError(error)
      }, encodingCompletion: { (r) in
        request = r
      })
      return Disposables.create {
        request?.cancel()
      }
    }
  }
}

extension ApiRequestWithData where ResultType: Decodable, ParametersType == [String: Any] {
  public var response: Observable<ResultType> {
    return Observable.create { (observer) -> Disposable in
      var request: Request? = nil
      self.request(success: { (result) in
        observer.onNext(result)
        observer.onCompleted()
      }, failure: { (error) in
        observer.onError(error)
      }, encodingCompletion: { (r) in
        request = r
      })
      return Disposables.create {
        request?.cancel()
      }
    }
  }
}
