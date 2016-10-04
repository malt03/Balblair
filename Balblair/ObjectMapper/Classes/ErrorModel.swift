//
//  ErrorModel.swift
//  Pods
//
//  Created by Koji Murata on 2016/09/07.
//
//

import Foundation

public protocol ErrorModelProtocol {
  static func create(_ error: Error, result: Any?) -> Self
}

public enum BalblairError: Error {
  case unknown
  case parseError
}

public struct DefaultErrorModel: ErrorModelProtocol {
  public var error: Error
  public var result: Any?
  public static func create(_ error: Error, result: Any?) -> DefaultErrorModel {
    return DefaultErrorModel(error: error, result: result)
  }
}
