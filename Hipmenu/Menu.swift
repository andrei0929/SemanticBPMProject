//
//  Menu.swift
//  Hipmenu
//
//  Created by Andrei Oltean on 10/02/2019.
//  Copyright © 2019 Andrei Oltean. All rights reserved.
//

import Foundation

struct MenusResult: Codable {
    var menus: [Menu]
    
    enum CodingKeys: String, CodingKey {
        case menus = "bindings"
    }
}

class Menu: Codable {
    var name: String
    var uri: String
    var items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case name
        case menu
    }
    
    enum NestedKeys: String, CodingKey {
        case type
        case value
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let nameInfo = try values.nestedContainer(keyedBy: NestedKeys.self, forKey: .name)
        name = try nameInfo.decode(String.self, forKey: .value)
        
        let menuInfo = try values.nestedContainer(keyedBy: NestedKeys.self, forKey: .menu)
        uri = try menuInfo.decode(String.self, forKey: .value)
        
        items = []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        var nameInfo = container.nestedContainer(keyedBy: NestedKeys.self, forKey: .name)
        try nameInfo.encode(name, forKey: .value)
        
        var menuInfo = container.nestedContainer(keyedBy: NestedKeys.self, forKey: .menu)
        try menuInfo.encode(name, forKey: .value)
    }
}
