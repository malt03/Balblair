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
  func handleError(_ error: MyErrorType) {
    print("hoge")
  }
}

struct MyErrorType: ErrorModelProtocol {
  public static func create(error: Error, result: Any?) -> MyErrorType {
    return MyErrorType()
  }
}

struct QiitaRequest: MyApiRequest {
  typealias ResultType = [QiitaResult]
  
  let method = Balblair.Method.get
  let path = "/api/v2/items?page=1&per_page=20"
  let parameters = ["page": "1", "per_page": "20"] as [String: Any]
}

struct QiitaResult: Mappable {
  var title = ""
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    title <- map["title"]
  }
}
