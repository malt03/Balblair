//
//  ApiRequestStatus.swift
//  Balblair
//
//  Created by Koji Murata on 2019/02/03.
//

import RxSwift
import Foundation

public enum ApiRequestStatus<ResultType> {
  case progress(Progress)
  case complete(ResultType)
}
