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
}

extension BalblairError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .unknown: return "unknown Balblair Error."
    }
  }
}

public struct ErrorModel<T: Decodable>: Error {
  public var error: Error
  public var result: T?
  public init(error: Error, result: Data?, decoder: JSONDecoder) {
    self.error = error
    if let result = result {
      self.result = try? decoder.decode(T.self, from: result)
    }
  }
}

extension ErrorModel: LocalizedError {
  public var errorDescription: String? {
    return error.localizedDescription
  }
}

public struct DefaultErrorResult: Decodable {}
