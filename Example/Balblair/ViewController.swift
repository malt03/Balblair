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
    _ = QiitaRequest().response.subscribe(onNext: { (result) in
      print(result)
    }, onError: { (error) in
      print(error)
    })
  }
}
