//
//  ErrorModel.swift
//  Pods
//
//  Created by Koji Murata on 2016/09/07.
//
//

import Foundation

public enum BalblairError: Error {
  case unknown
  case parseError
}

public struct ErrorModel<T: Decodable>: Error {
  public var error: Error
  public var result: T?
  public init(error: Error, result: Data?) {
    self.error = error
    if let result = result {
      self.result = try? JSONDecoder().decode(T.self, from: result)
    }
  }
}

public struct DefaultErrorResult: Decodable {}
