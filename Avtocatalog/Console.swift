//
//  Console.swift
//  Avtocatalog
//
//  Created by Student on 02/04/2019.
//  Copyright © 2019 Student. All rights reserved.
//

import Foundation

enum Commands: String {
    case none
    case showAll = "showall"
    case addCar = "addcar"
    case deleteCar = "deletecar"
    case editCar = "editcar"
    case help
    case exit
    
    static let allValues: [Commands] = [.showAll, .addCar, .deleteCar, .editCar, .help, .exit]
}

class Console {
    fileprivate let carsStorage = CarsStorage.shared
    
    func run() {
        var command: Commands = .none
        var userInput: String = ""
        printAllCommands()
        repeat {
            print("Type command and press Enter: ", separator: "", terminator: "")
            userInput = readLine()?.lowercased() ?? ""
            command = analizeCommandFrom(userInput)
            perform(&command)
            
        } while userInput != Commands.exit.rawValue
    }
    
    private func perform(_ command: inout Commands) {
        switch command {
        case .showAll:
            printAllCars()
            command = .none
        case .addCar:
            addCar()
            command = .none
        case .deleteCar:
            deleteCar()
            command = .none
        case .editCar:
            editCar()
            command = .none
        case .help: printAllCommands()
        default: break
        }
    }
    
    private func printAllCommands(){
        print("List of available commands: \n", separator: "", terminator: "")
        Commands.allValues.forEach { (command) in
            print(command)
        }
    }
    
    private func analizeCommandFrom(_ userInput: String) -> Commands {
        switch userInput {
        case "showall": return Commands.showAll
        case "addcar": return Commands.addCar
        case "deletecar": return Commands.deleteCar
        case "editcar": return Commands.editCar
        case "help": return Commands.help
        default: return Commands.none
        }
        
    }
    
    private func printAllCars() {
        if carsStorage.load() {
            for index in carsStorage.cars.indices {
                let car = carsStorage.cars[index]
                print("\(index + 1).", separator: "", terminator: "")
                for property in Car.Property.allValues {
                    print(" \(property): \(car[property])", separator: "", terminator: ";")
                }
                print("")
            }
        } else {
            print("There is no any car in storage yet.")
        }
    }
    
    private func addCar() {
        let newCar = Car()
        for property in Car.Property.allValues {
            print("Please input \(property): ", separator: "", terminator: "")
            let userInput = readLine() ?? ""
            newCar[property] = analizePropertyFrom(userInput, for: property)
        }
        if carsStorage.append(car: newCar) {
            print("Car was added succefully!")
        } else {
            print("Something went wrong...")
        }
    }
    
    private func deleteCar() {
        print("Please input number of car to delete: ", separator: "", terminator: "")
        let userInput = readLine() ?? ""
        guard let indexCar = Int(userInput), indexCar > 0, indexCar <= carsStorage.cars.count else {
            print("Incorrect car number!")
            return
        }
        if carsStorage.remove(carAtIndex: indexCar) {
            print("Car at \(indexCar) removed succefully!")
        } else {
            print("Something went wrong...")
        }
        
    }
    
    private func editCar() {
        print("Please input number to edit car: ", separator: "", terminator: "")
        let userInput = readLine() ?? ""
        guard let indexCar = Int(userInput), indexCar > 0, indexCar <= carsStorage.cars.count else {
            print("Incorrect car number!")
            return
        }
        let oldCar = carsStorage.cars[indexCar - 1]
        let newCar = Car()
        for property in Car.Property.allValues {
            print("Input new value for \(property) or press Enter to keep old value (\(oldCar[property])): ", separator: "", terminator: "")
            let userInput = readLine() ?? ""
            if userInput == "" {
                newCar[property] = oldCar[property]
            } else {
                newCar[property] = analizePropertyFrom(userInput, for: property)
            }
        }
        if carsStorage.modify(oldCar: oldCar, newCar: newCar) {
            print("Car editing saved.")
        } else {
            print("Something went wrong...")
        }
    }
    
    private func analizePropertyFrom (_ userInput: String, for property: Car.Property) -> String {
        if property == Car.Property.year {
            let currentYear = Date().yearAsInt()
            if let year = Int(userInput), year > 1806, year < currentYear {
                return String(year)
            } else {
                print("Year you entered NOT coorect!")
                print("Please input \(property): ", separator: "", terminator: "")
                let userInput = readLine() ?? ""
                return analizePropertyFrom(userInput, for: property)
            }
        }
        return userInput
    }
}
