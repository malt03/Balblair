//
//  QiitaRequest.swift
//  ApiClient
//
//  Created by Koji Murata on 2016/08/04.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import Foundation
import Balblair
import ObjectMapper

protocol MyApiRequest: ApiRequest {}
extension MyApiRequest {
  func didFailure(error: MyErrorType) {
    print(error)
  }
  
  func didSuccess(result: Self.ResultType) {
    print(result)
  }
  
  func willBeginRequest(parameters: Self.ParametersType) {
    print(parameters)
  }
}

struct MyErrorType: ErrorModelProtocol {
  let error: Error
  public static func create(error: Error, result: Any?) -> MyErrorType {
    return MyErrorType(error: error)
  }
}

struct QiitaRequest: MyApiRequest {
  typealias ResultType = [QiitaResult]
  
  let method = Balblair.Method.get
  let path = "api/v2/items"
  let parameters = ["page": "1", "per_page": "20"] as [String: Any]
}

struct QiitaResult: Mappable {
  var title = ""
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    title <- map["title"]
  }
}
