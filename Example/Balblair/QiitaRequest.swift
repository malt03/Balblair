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

struct QiitaRequest: ApiRequest {
  typealias ResultType = [QiitaResult]

  let method = Balblair.Method.GET
  let path = "api/v2/items"
  let parameters = NoParamsModel()
}

struct QiitaResult: Mappable {
  var title = ""
  
  init?(_ map: Map) {
    mapping(map)
  }
  
  mutating func mapping(map: Map) {
    title <- map["title"]
  }
}
