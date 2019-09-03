//
//  LocalData.swift
//  DogDiary
//
//  Created by Ingyu Woo on 8/25/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import Foundation
import FirebaseFirestore

class LocalData {
    static let sharedInstance = LocalData()
    
    let db = Firestore.firestore()
    
    var dogs: [Dog] = []
    var selectedDogIndex: Int = -1
    
    var logs: [Log] = []
    
    func getCurrentDogName() -> String {
        if LocalData.sharedInstance.selectedDogIndex > -1 && LocalData.sharedInstance.selectedDogIndex <= LocalData.sharedInstance.dogs.count - 1 {
            return LocalData.sharedInstance.dogs[LocalData.sharedInstance.selectedDogIndex].name
        } else {
            return ""
        }
    }
    
    func getCurrentDog() -> Dog? {
        if LocalData.sharedInstance.selectedDogIndex > -1 && LocalData.sharedInstance.selectedDogIndex <= LocalData.sharedInstance.dogs.count - 1 {
            return LocalData.sharedInstance.dogs[LocalData.sharedInstance.selectedDogIndex]
        } else {
            return nil
        }
    }
}
