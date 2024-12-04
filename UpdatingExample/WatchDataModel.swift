//
//  WatchDataModel.swift
//  Set Buddy Watch App
//
//  Created by Christian Schuster on 07.11.24.
//

import SwiftUI
import OSLog
import Observation

extension Logger {
    static var dataModel: Logger {
        return Logger(subsystem: "Example", category: "Datamodel")
    }
}


@Observable
class WatchDataModel {
    
    var items: [MyObservableItem] = []
    private(set) var version: Int = 0
    
    static let shared = WatchDataModel()
    
    
//    init() {
//        
//    }
    
    convenience init(items: [MyObservableItem]) {
        self.init()
        self.items = items
    }
    
    convenience init(preview: Bool = false) {
        self.init()
        if preview == true {
            self.items = MyObservableItem.exampleItems(.large)
        }
    }
    
    func readItems(from messageData: Data) {
        
        Logger.dataModel.warning("Dont use this function, use synchronize(from messageData: Data)")
        
        Logger.dataModel.info("readItems...")
        
        self.dumpArray(self.items)
        // Dump the content of the json data
        if let string = String(data: messageData, encoding: .utf8) {
            Logger.dataModel.debug("Decoded JSON: \(string)")
        }
        
        
        
        var message: TransportMessage?
        
        do {
            let decoder = JSONDecoder()
            message = try decoder.decode(TransportMessage.self, from: messageData)
        } catch  {
            Logger.dataModel.error("Error decoding: \(error)")
            message = nil
        }
        
        Logger.dataModel.info("√ Could decode data to TransportMessage")
        
        guard let message = message else {
            Logger.dataModel.error("No valid Transport message received")
            return
        }
        
        Logger.dataModel.info("√ TransportMessage valid")
        
        
        
            
        DispatchQueue.main.async { [self] in
            withAnimation {
                let nextArray = message.payload
                nextArray[0].id = UUID()
                nextArray[0].currentValue = Int.random(in: 1...100)
//                self.items = nextArray
                
                for (_, arrayItem) in nextArray.enumerated() {
                    arrayItem.updateProgress()
                }
                
                self.items.removeAll()
                self.items.append(contentsOf: nextArray)
                
                self.version += 1 // Increment version to trigger UI updates
                
            }
        }

        self.dumpArray(self.items)
        
        
        
//        for (index, item) in message.payload.enumerated() {
//            self.items.append(item)
//        }

        
        //}
        
        
        
    }
    
    func synchronize(from messageData: Data) {
        
        var message: TransportMessage? = nil
        do {
            let decoder = JSONDecoder()
            message = try decoder.decode(TransportMessage.self, from: messageData)
        } catch  {
            Logger.dataModel.error("Error decoding: \(error)")
        }
        
        // Step 1: Create a dictionary of the current items by id for fast lookups
        var currentItemsDict = [UUID: MyObservableItem]()
        for item in items {
            currentItemsDict[item.id] = item
        }
        
        
        guard let message = message else {
            Logger.dataModel.error("No message received")
            return
        }
        
        let updatedItems = message.payload
        
        // Step 2: Update existing items and add new ones
        for updatedItem in updatedItems {
            if let existingItem = currentItemsDict[updatedItem.id] {
                // Item exists, update its properties
                existingItem.currentValue = updatedItem.currentValue
                existingItem.lastSubmittedValue = updatedItem.lastSubmittedValue
                existingItem.name = updatedItem.name
                existingItem.colorString = updatedItem.colorString
                existingItem.targetValue = updatedItem.targetValue
                existingItem.order = updatedItem.order
                existingItem.updateProgress()
            } else {
                // New item, add to the list
                items.append(updatedItem)
            }
            // Remove the item from the dictionary to track what was not updated
            currentItemsDict[updatedItem.id] = nil
        }
        
        // Step 3: Remove any items that were not in the updated list
        items.removeAll { item in
            currentItemsDict[item.id] != nil
        }
        
        // Step 4: Reorder the items based on the updatedItems order
        // This ensures that the order of items matches the updated array
        let idToItemMap = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0) })
        items = updatedItems.compactMap { updatedItem in
            idToItemMap[updatedItem.id]
        }
        
        self.version += 1 
        
    }
    
    
    private func dumpArray(_ array: [MyObservableItem]) {
        Logger.dataModel.info("Array dump:")
        for item in array {
            Logger.dataModel.info("\(item.name) \(item.currentValue)")
        }
    }
    
    
    
    func update(activityItem: MyObservableItem, reps: Int) {
        
        
        
        let index = items.firstIndex { loopItem in
            return loopItem.id.uuidString == activityItem.id.uuidString
        }
        
        guard let index = index else {
            print("Could not find activity to update")
            return
        }
        
        print("updating activity \(items[index].name) from \(items[index].currentValue) to \(items[index].currentValue + reps)")
        
        
//        items[index].currentValue += reps
//        items[index].lastSubmittedValue = reps
//        items[index].updateProgress()
//        items[index] = items[index]
        
//        activityItem.currentValue += reps
//        activityItem.lastSubmittedValue = reps
//        activityItem.updateProgress()
        
        
    }
    
    func debugReplaceArray(synchronize: Bool = true) {
        
        let string = """
{
        "payload" : [
          {
            "targetValue" : 200,
            "name" : "Luigi",
            "persistentIDString" : "",
            "order" : 0,
            "lastSubmittedValue" : 20,
            "currentValue" : 20,
            "id" : "C6BC22E2-50D2-4C50-A32F-9E8B4FD048A3",
            "colorString" : "1.000000,0.215686,0.372549,1.000000"
          },
          {
            "id" : "E9BB48F1-4FD1-4F37-967D-BDD123BE6C74",
            "persistentIDString" : "",
            "colorString" : "1.080819,0.352992,1.029201,1.000000",
            "order" : 0,
            "targetValue" : 200,
            "currentValue" : 0,
            "lastSubmittedValue" : 15,
            "name" : "Mario"
          },
          {
            "currentValue" : 0,
            "id" : "01F5E566-7AD9-4137-87D4-8F4B6A103EFE",
            "targetValue" : 90,
            "persistentIDString" : "",
            "colorString" : "1.000000,0.682353,0.011765,1.000000",
            "name" : "Toad",
            "lastSubmittedValue" : 20,
            "order" : 0
          },
          {
            "colorString" : "0.988235,1.000000,0.239216,1.000000",
            "order" : 0,
            "targetValue" : 300,
            "currentValue" : 0,
            "persistentIDString" : "",
            "id" : "77A19B2C-3DE1-4489-9EAC-4FD7E079F506",
            "lastSubmittedValue" : 30,
            "name" : "Peach"
          },
          {
            "colorString" : "0.996078,0.984314,0.254902,1.000000",
            "targetValue" : 11,
            "lastSubmittedValue" : 4,
            "persistentIDString" : "",
            "name" : "Bowser",
            "order" : 0,
            "currentValue" : 0,
            "id" : "71E8CE37-BFDC-407E-852D-67B90E4A14F2"
          },
          {
            "colorString" : "0.235294,0.858824,0.827451,1.000000",
            "persistentIDString" : "",
            "name" : "Yoshi",
            "id" : "F2D9A628-7275-4F5A-8F1B-A8514F042C40",
            "lastSubmittedValue" : 5,
            "order" : 0,
            "targetValue" : 10,
            "currentValue" : 0
          },
          {
            "colorString" : "1.000000,0.176471,0.333333,1.000000",
            "order" : 0,
            "targetValue" : 10,
            "currentValue" : 0,
            "name" : "Peach",
            "lastSubmittedValue" : 0,
            "persistentIDString" : "",
            "id" : "EB7F1FCD-DF3A-46F5-88BD-764D55026C11"
          },
          {
            "persistentIDString" : "",
            "currentValue" : 0,
            "name" : "Boo",
            "colorString" : "1.000000,0.215686,0.372549,1.000000",
            "targetValue" : 10,
            "lastSubmittedValue" : 0,
            "order" : 0,
            "id" : "B1975E7D-B844-48CA-9D2F-F7A4D2750AF8"
          },
          {
            "name" : "Lakitu",
            "persistentIDString" : "",
            "lastSubmittedValue" : 0,
            "id" : "3E5AEFE1-7F72-4894-9072-5F1EE2BAD8D4",
            "order" : 0,
            "targetValue" : 10,
            "currentValue" : 0,
            "colorString" : "0.647059,1.000000,0.164706,1.000000"
          },
          {
            "currentValue" : 0,
            "order" : 0,
            "persistentIDString" : "",
            "targetValue" : 300,
            "id" : "839ACB31-5C62-42A3-87FD-2519252E4019",
            "lastSubmittedValue" : 20,
            "name" : "Blooper",
            "colorString" : "1.000000,1.000000,1.000000,1.000000"
          }
        ],
        "type" : "model"
      }
"""
        
        
        let data = string.data(using: .utf8)!
        //self.readItems(from: data)
        withAnimation {
            if synchronize {
                self.synchronize(from: data)
            } else {
                self.readItems(from: data)
            }
        }
        
        
        
    }
    
    
    
}
