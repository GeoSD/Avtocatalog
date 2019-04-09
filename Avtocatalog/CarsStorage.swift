//
//  CarsStorage.swift
//  Avtocatalog
//
//  Created by Student on 02/04/2019.
//  Copyright © 2019 Student. All rights reserved.
//

import Foundation

class CarsStorage {
    static let shared = CarsStorage()
    var cars: [Car] = []
    private lazy var fileURL: URL = {
        let directoryURL = FileManager.default.homeDirectoryForCurrentUser
        return directoryURL.appendingPathComponent("cars.data")
    }()
    
    init() {
        load()
    }
    
    func append(car: Car) -> Bool {
        cars.append(car)
        return save()
    }
    
    func remove(carAtIndex index: Int) -> Bool {
        cars.remove(at: index - 1)
        return save()
    }
    
    func modify(oldCar: Car, newCar: Car) -> Bool {
        if let index = cars.firstIndex(where: { oldCar === $0 }) {
            cars[index] = newCar
            return save()
        }
        return false
    }
    
    private func save() -> Bool {
        if let data: Data = try? JSONEncoder().encode(cars) {
            return nil != (try? data.write(to: fileURL))
        }
        return false
    }
    
    @discardableResult
    func load() -> Bool {
        do {
            let data = try Data(contentsOf: fileURL)
            cars = try JSONDecoder().decode([Car].self, from: data)
            return true
        } catch {
            return false
        }
    }
}
