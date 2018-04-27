//
//  DefaultConfigurationHolder.swift
//  Balblair
//
//  Created by Koji Murata on 2018/04/27.
//

import Foundation

final class DefaultConfigurationHolder {
  static let shared = DefaultConfigurationHolder()
  private init() {}
  
  lazy var configuration: BalblairConfiguration = { preconditionFailure("You did not set Balblair.defaultConfiguration.") }()
}
