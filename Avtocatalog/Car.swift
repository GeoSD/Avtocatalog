//
//  Car.swift
//  Avtocatalog
//
//  Created by Student on 02/04/2019.
//  Copyright © 2019 Student. All rights reserved.
//

import Foundation

class Car: Codable {
    enum Property: String {
        case year
        case model
        case manufact
        case `class`
        case bodyType
        
        static let allValues: [Property] = [.year, .model, .manufact, .class, .bodyType]
    }
    private var data: [String] = []
    
    subscript(property: Property) -> String {
        get {
            if let index = Property.allValues.firstIndex(of: property), index < data.count {
                return data[index]
            }
            return ""
        }
        set {
            if let index = Property.allValues.firstIndex(of: property) {
                while data.count <= index {
                    data.append("")
                }
                data[index] = newValue
            }
        }
    }
    
    init() {
        data = [String](repeating: "", count: Property.allValues.count)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        data = try container.decode([String].self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(data)
    }
}
