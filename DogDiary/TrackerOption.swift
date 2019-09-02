//
//  TrackerOption.swift
//  DogDiary
//
//  Created by Ingyu Woo on 9/1/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import Foundation

enum TrackerOption: String, CaseIterable {
    case Eat
    case Poop
    case Pee
    case Play
    case Walk
    
    init?(id : Int) {
        switch id {
        case 1: self = .Eat
        case 2: self = .Poop
        case 3: self = .Pee
        case 4: self = .Play
        case 5: self = .Walk
        default: return nil
        }
    }
}
