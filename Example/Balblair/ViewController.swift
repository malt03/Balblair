//
//  ViewController.swift
//  ApiClient
//
//  Created by Koji Murata on 08/03/2016.
//  Copyright (c) 2016 Koji Murata. All rights reserved.
//

import UIKit
import Balblair
import RxSwift

class ViewController: UIViewController, UIScrollViewDelegate {
  
  @IBAction private func push() {
//    Balblair().get("api/v2/items", success: { (result) in
//      print(result)
//    })

//    QiitaRequest().request(progress: { print($0) }, success: { print($0) }, failure: { print($0, $1) })
    
    QiitaRequest().createTask().success { (result) in
      print(result.map { $0.title })
    }
    
//    _ = QiitaRequest().response.subscribeNext { (result) in
//      print(result.map { $0.title })
//    }
  }
}
