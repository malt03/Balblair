//
//  ApiRequestWithData+Rx.swift
//  Pods
//
//  Created by Koji Murata on 2016/12/06.
//
//

import Alamofire
import RxSwift

extension ApiRequest where ResultType: Decodable, ParametersType: Encodable {
  public var response: Observable<ResultType> {
    return Observable.create { (observer) -> Disposable in
      var request: Request? = nil
      self.request(
        requestCreated: { request = $0 },
        success: { (result) in
          observer.onNext(result)
          observer.onCompleted()
        },
        failure: { observer.onError($0) }
      )
      return Disposables.create {
        request?.cancel()
      }
    }
  }
  
  public var responseWithProgress: Observable<ApiRequestStatus<ResultType>> {
    return Observable.create { (observer) -> Disposable in
      var request: Request? = nil
      self.request(
        requestCreated: { request = $0 },
        progress: { (progress) in
          observer.onNext(.progress(progress))
        },
        success: { (result) in
          observer.onNext(.complete(result))
          observer.onCompleted()
        },
        failure: { observer.onError($0) }
      )
      return Disposables.create {
        request?.cancel()
      }
    }
  }
}

extension ApiRequest where ResultType: Decodable, ParametersType == [String: Any] {
  public var response: Observable<ResultType> {
    return Observable.create { (observer) -> Disposable in
      var request: Request? = nil
      self.request(
        requestCreated: { request = $0 },
        success: { (result) in
          observer.onNext(result)
          observer.onCompleted()
        },
        failure: { observer.onError($0) }
      )
      return Disposables.create {
        request?.cancel()
      }
    }
  }
  
  public var responseWithProgress: Observable<ApiRequestStatus<ResultType>> {
    return Observable.create { (observer) -> Disposable in
      var request: Request? = nil
      self.request(
        requestCreated: { request = $0 },
        progress: { (progress) in
          observer.onNext(.progress(progress))
        },
        success: { (result) in
          observer.onNext(.complete(result))
          observer.onCompleted()
        },
        failure: { observer.onError($0) }
      )
      return Disposables.create {
        request?.cancel()
      }
    }
  }
}
