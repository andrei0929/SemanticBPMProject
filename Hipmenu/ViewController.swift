//
//  ViewController.swift
//  Hipmenu
//
//  Created by Maria Pandrea on 09/02/2019.
//  Copyright © 2019 Andrei Oltean. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    SPARQLClient.instance.seeAllMenus()
    
  }


}

