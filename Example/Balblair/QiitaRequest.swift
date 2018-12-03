//
//  QiitaRequest.swift
//  ApiClient
//
//  Created by Koji Murata on 2016/08/04.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import Foundation
import Balblair

struct QiitaRequest: MyApiRequest {
  typealias ResultType = [QiitaResult]
  
  let method = Balblair.Method.get
  let path = "api/v2/items"
  let parameters = QiitaParameters()
}

struct QiitaResult: Decodable {
  let title: String
}

struct QiitaParameters: Encodable {
  let page = 1
  let per_page = 21
}

protocol MyApiRequest: ApiRequest {}
extension MyApiRequest {
  func didFailure(error: ErrorModel<MyErrorResultType>) {}
  
  func didSuccess(result: Self.ResultType) {}
  
  func willBeginRequest(parameters: Self.ParametersType) {}
}

struct MyErrorResultType: Decodable {
}

