//
//  BalblairHeader.swift
//  Pods
//
//  Created by Koji Murata on 2016/08/25.
//
//

import Foundation

public protocol BalblairHeaderBuilder {
  func build() -> [String: String]
}
