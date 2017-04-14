//
//  ApiRequestWithData+Rx.swift
//  Pods
//
//  Created by Koji Murata on 2016/12/06.
//
//

import Alamofire
import RxSwift
import ObjectMapper

extension ApiRequestWithData where ResultType: Mappable, ParametersType: Mappable {
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

extension ApiRequestWithData where ResultType: ExpressibleByArrayLiteral, ResultType.Element: Mappable, ParametersType: Mappable {
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

extension ApiRequestWithData where ResultType: Mappable, ParametersType == [String: Any] {
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

extension ApiRequestWithData where ResultType: ExpressibleByArrayLiteral, ResultType.Element: Mappable, ParametersType == [String: Any] {
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
