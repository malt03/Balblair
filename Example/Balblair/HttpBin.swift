//
//  HttpBin.swift
//  Balblair_Example
//
//  Created by Koji Murata on 2019/10/18.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Balblair

struct HttpBinRequest: ApiRequest {
  typealias ResultType = NoValue
  var encodeType: EncodeType { return .form }
  
  let method = Balblair.Method.post
  let path = "/post"
  let parameters = ["aa": [1, 2]]
  var uploadData: [Balblair.UploadData]? {
    return [
      Balblair.UploadData(
        data: "hoge".data(using: .utf8)!,
        name: "aa[0]",
        fileName: "1.txt",
        mimeType: "text/plain"
      ),
      Balblair.UploadData(
        data: "piyo".data(using: .utf8)!,
        name: "aa[1]",
        fileName: "2.txt",
        mimeType: "text/plain"
      ),
    ]
  }
}
