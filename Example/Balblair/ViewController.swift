//
//  ViewController.swift
//  ApiClient
//
//  Created by Koji Murata on 08/03/2016.
//  Copyright (c) 2016 Koji Murata. All rights reserved.
//

import UIKit
import Balblair

class ViewController: UIViewController, UIScrollViewDelegate {
  @IBAction fileprivate func push() {
    _ = HttpBinRequest().responseWithProgress.subscribe(onNext: { (status) in
      switch status {
      case .progress(let progress):
        print(progress.fractionCompleted)
      case .complete(let result):
        print(result)
      }
    }, onError: { (error) in
      print(error)
    })
  }
}
