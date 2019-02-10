//
//  Item.swift
//  Hipmenu
//
//  Created by Andrei Oltean on 10/02/2019.
//  Copyright © 2019 Andrei Oltean. All rights reserved.
//

import Foundation

struct ItemsResult: Codable {
    var items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case items = "bindings"
    }
}

class Item: Codable {
    var name: String
    var uri: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case item
    }
    
    enum NestedKeys: String, CodingKey {
        case type
        case value
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let nameInfo = try values.nestedContainer(keyedBy: NestedKeys.self, forKey: .name)
        name = try nameInfo.decode(String.self, forKey: .value)
        
        let itemInfo = try values.nestedContainer(keyedBy: NestedKeys.self, forKey: .item)
        uri = try itemInfo.decode(String.self, forKey: .value)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        var nameInfo = container.nestedContainer(keyedBy: NestedKeys.self, forKey: .name)
        try nameInfo.encode(name, forKey: .value)
        
        var itemInfo = container.nestedContainer(keyedBy: NestedKeys.self, forKey: .item)
        try itemInfo.encode(name, forKey: .value)
    }
}
