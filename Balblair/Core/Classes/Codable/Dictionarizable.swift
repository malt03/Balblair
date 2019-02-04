//
//  Encodable+Extensions.swift
//  Alamofire
//
//  Created by Koji Murata on 2018/04/27.
//

import Foundation

extension Encodable {
  func createDictionary(encoder: JSONEncoder) -> [String: Any]? {
    guard let data = try? encoder.encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
