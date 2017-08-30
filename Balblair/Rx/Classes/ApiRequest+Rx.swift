//
//  ApiRequest+Rx.swift
//  Pods
//
//  Created by Koji Murata on 2016/12/06.
//
//

import Alamofire
import RxSwift
import ObjectMapper

extension ApiRequest where ResultType: Mappable, ParametersType: Mappable {
  public var response: Observable<ResultType> {
    return Observable.create { (observer) -> Disposable in
      let request = self.request(success: { (result) in
        observer.onNext(result)
        observer.onCompleted()
      }, failure: { (error) in
        observer.onError(error)
      })
      return Disposables.create {
        request.cancel()
      }
    }
  }
}

extension ApiRequest where ResultType: ExpressibleByArrayLiteral, ResultType.ArrayLiteralElement: Mappable, ParametersType: Mappable {
  public var response: Observable<ResultType> {
    return Observable.create { (observer) -> Disposable in
      let request = self.request(success: { (result) in
        observer.onNext(result)
        observer.onCompleted()
      }, failure: { (error) in
        observer.onError(error)
      })
      return Disposables.create {
        request.cancel()
      }
    }
  }
}

extension ApiRequest where ResultType: Mappable, ParametersType == [String: Any] {
  public var response: Observable<ResultType> {
    return Observable.create { (observer) -> Disposable in
      let request = self.request(success: { (result) in
        observer.onNext(result)
        observer.onCompleted()
      }, failure: { (error) in
        observer.onError(error)
      })
      return Disposables.create {
        request.cancel()
      }
    }
  }
}

extension ApiRequest where ResultType: ExpressibleByArrayLiteral, ResultType.ArrayLiteralElement: Mappable, ParametersType == [String: Any] {
  public var response: Observable<ResultType> {
    return Observable.create { (observer) -> Disposable in
      let request = self.request(success: { (result) in
        observer.onNext(result)
        observer.onCompleted()
      }, failure: { (error) in
        observer.onError(error)
      })
      return Disposables.create {
        request.cancel()
      }
    }
  }
}
