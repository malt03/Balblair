//
//  Mappable+Extensions.swift
//  Pods
//
//  Created by Koji Murata on 2016/08/04.
//
//

import Foundation
import ObjectMapper

extension Mappable {
  static func parse(response: AnyObject?) -> Self? {
    return Mapper().map(response)
  }
}
