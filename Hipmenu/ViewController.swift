//
//  ViewController.swift
//  Hipmenu
//
//  Created by Maria Pandrea on 09/02/2019.
//  Copyright © 2019 Andrei Oltean. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var orderId: Int = 0
    var menus: [Menu] = []
    
    private let cellReuseIdentifier = "cell"
    private var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Register the table view cell class and its reuse id
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        SPARQLClient.instance.seeAllMenus { (menus, error) in
            guard error == nil else { return }
            
            if let menus = menus {
                self.menus = menus
                for menu in menus {
                    SPARQLClient.instance.seeItems(from: menu, completion: { (items, error) in
                        guard error == nil else { return }
                        
                        if let items = items {
                            menu.items = items
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func addItemToOrder(_ sender: UIButton) {
        guard let indexPath = selectedIndexPath else { return }
        
        SPARQLClient.instance.addItem(item: menus[indexPath.section].items[indexPath.row], to: "\(orderId)") { (error) in
            guard error == nil else { return }
        }
    }
    
    @IBAction func viewOrder(_ sender: UIButton) {
        
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menus[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        cell.textLabel?.text = menus[indexPath.section].items[indexPath.row].name
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
    }
}
