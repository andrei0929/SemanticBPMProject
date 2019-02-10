//
//  RootViewController.swift
//  Hipmenu
//
//  Created by Andrei Oltean on 10/02/2019.
//  Copyright © 2019 Andrei Oltean. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    private var orderId = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createNewOrder(_ sender: UIButton) {
        orderId += 1
        SPARQLClient.instance.createOrder(with: "\(orderId)") { (error) in
            guard error == nil else { return }
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let allItemsViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            allItemsViewController.orderId = self.orderId
            self.navigationController?.pushViewController(allItemsViewController, animated: true)
        }
    }
}
