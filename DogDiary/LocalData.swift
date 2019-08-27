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
}
