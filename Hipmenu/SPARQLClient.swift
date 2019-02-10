//
//  SPARQLClient.swift
//  Hipmenu
//
//  Created by Maria Pandrea on 09/02/2019.
//  Copyright © 2019 Andrei Oltean. All rights reserved.
//

import Foundation

class SPARQLClient {
    
    static let instance = SPARQLClient()
    
    private let baseURL = "http://localhost:7200/repositories/SBPMProject"
    
    private let menusQuery = """
PREFIX : <http://andrei.oltean#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

select ?menu ?name
{
    ?menu a :Menu.
    ?menu :hasDisplayName ?name.
}
"""
    
    func seeAllMenus(completion: @escaping ([Menu]?, Error?) -> Void) {
        var urlComponents = URLComponents(string: baseURL)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: menusQuery)
        ]
        
        guard let url = urlComponents.url else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            // check for any errors
            guard error == nil else {
                completion(nil, error)
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result
            do {
                guard let response = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                
                guard let results = response["results"] as? [String: Any] else {
                    return
                }
                
                let jsonData = try JSONSerialization.data(withJSONObject: results, options: [])
                
                let menusResult = try JSONDecoder().decode(MenusResult.self, from: jsonData)
                completion(menusResult.menus, nil)
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    func seeItems(from menu: Menu, completion: @escaping ([Item]?, Error?) -> Void) {
        var urlComponents = URLComponents(string: baseURL)!
        
        let getItemsQuery = """
PREFIX : <http://andrei.oltean#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

select ?item ?name
{
    <\(menu.uri)> a :Menu.
    <\(menu.uri)> :contains ?item.
    ?item :hasDisplayName ?name.
}
"""
        
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: getItemsQuery)
        ]
        
        guard let url = urlComponents.url else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            // check for any errors
            guard error == nil else {
                completion(nil, error)
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result
            do {
                guard let response = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                
                guard let results = response["results"] as? [String: Any] else {
                    return
                }
                
                let jsonData = try JSONSerialization.data(withJSONObject: results, options: [])
                
                let itemsResult = try JSONDecoder().decode(ItemsResult.self, from: jsonData)
                completion(itemsResult.items, nil)
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    func createOrder(with id: String, completion: @escaping (Error?) -> Void) {
        let createOrderQuery = """
PREFIX : <http://andrei.oltean#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

insert data
{
:Order\(id) a :Order.
}
"""
        
        var urlComponents = URLComponents(string: baseURL + "/statements")!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: createOrderQuery)
        ]
        
        guard let url = urlComponents.url else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            // check for any errors
            guard error == nil else {
                completion(error)
                print(error!)
                return
            }
            // make sure we got data
            guard data != nil else {
                print("Error: did not receive data")
                return
            }
            completion(nil)
        }
        task.resume()
    }
    
    func addItem(item: Item, to orderId: String, completion: @escaping (Error?) -> Void) {
        let addItemQuery = """
PREFIX : <http://andrei.oltean#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

insert data
{
    :Order\(orderId) a :Order.
    :Order\(orderId) :contains <\(item.uri)>.
}
"""
        
        var urlComponents = URLComponents(string: baseURL + "/statements")!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "update", value: addItemQuery)
        ]
        
        guard let url = urlComponents.url else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            // check for any errors
            guard error == nil else {
                completion(error)
                print(error!)
                return
            }
            // make sure we got data
            guard data != nil else {
                print("Error: did not receive data")
                return
            }
            completion(nil)
        }
        task.resume()
    }
}
