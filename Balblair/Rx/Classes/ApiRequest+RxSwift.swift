//
//  ApiRequest+RxSwift.swift
//  Pods
//
//  Created by Koji Murata on 2016/08/24.
//
//

import Foundation
import RxSwift
import ObjectMapper

extension ApiRequest where ResultType: Mappable, ParametersType: Mappable {
  public var response: Observable<ResultType> {
    return Observable.create { (observer) -> Disposable in
      let request = self.request(success: { (result) in
        observer.onNext(result)
        observer.onCompleted()
        }, failure: { (result, error) in
          observer.onError(error)
      })
      return AnonymousDisposable(request.cancel)
    }
  }
}

extension ApiRequest where ResultType: _ArrayType, ResultType.Element: Mappable, ParametersType: Mappable {
  public var response: Observable<ResultType> {
    return Observable.create { (observer) -> Disposable in
      let request = self.request(success: { (result) in
        observer.onNext(result)
        observer.onCompleted()
        }, failure: { (result, error) in
          observer.onError(error)
      })
      return AnonymousDisposable(request.cancel)
    }
  }
}

extension ApiRequest where ResultType: Mappable, ParametersType == [String: AnyObject] {
  public var response: Observable<ResultType> {
    return Observable.create { (observer) -> Disposable in
      let request = self.request(success: { (result) in
        observer.onNext(result)
        observer.onCompleted()
        }, failure: { (result, error) in
          observer.onError(error)
      })
      return AnonymousDisposable(request.cancel)
    }
  }
}

extension ApiRequest where ResultType: _ArrayType, ResultType.Element: Mappable, ParametersType == [String: AnyObject] {
  public var response: Observable<ResultType> {
    return Observable.create { (observer) -> Disposable in
      let request = self.request(success: { (result) in
        observer.onNext(result)
        observer.onCompleted()
        }, failure: { (result, error) in
          observer.onError(error)
      })
      return AnonymousDisposable(request.cancel)
    }
  }
}
