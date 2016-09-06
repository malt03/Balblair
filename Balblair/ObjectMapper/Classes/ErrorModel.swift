//
//  ErrorModel.swift
//  Pods
//
//  Created by Koji Murata on 2016/09/07.
//
//

import Foundation

public protocol ErrorModelProtocol {
  static func create(error: ErrorType, result: AnyObject?) -> Self
}

public enum BalblairError: ErrorType {
  case Unknown
  case ParseError
}

public struct DefaultErrorModel: ErrorModelProtocol {
  public var error: ErrorType
  public var result: AnyObject?
  public static func create(error: ErrorType, result: AnyObject?) -> DefaultErrorModel {
    return DefaultErrorModel(error: error, result: result)
  }
}
