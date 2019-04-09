//
//  Extension+Date.swift
//  Avtocatalog
//
//  Created by Georgy Dyagilev on 09/04/2019.
//  Copyright © 2019 Student. All rights reserved.
//

import Foundation
extension Date {
    func yearAsInt() -> Int {
        let yearAsInt = Calendar.current.component(.year, from: self)
        return yearAsInt
    }
}
