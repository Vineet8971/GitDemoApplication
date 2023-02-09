//
//  CoreDataManager.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 27/12/2022.
//

import UIKit
import CoreData

struct CoreDataManager {
    static var shared = CoreDataManager()
    
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func save(object:[String:String]) {
        let location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: context!) as! Location
        location.lat = object["lat"]
        location.long = object["long"]
        location.address = object["address"]
        do {
            try context?.save()
        }
        catch {
            print("data is not saved")
        }
    }
    
}

