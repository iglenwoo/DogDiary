//
//  LocalData.swift
//  DogDiary
//
//  Created by Ingyu Woo on 8/25/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import Foundation

class LocalData {
    static let sharedInstance = LocalData()
    var dogs: [Dog] = []
    var selectedDogIndex: Int = -1
}
