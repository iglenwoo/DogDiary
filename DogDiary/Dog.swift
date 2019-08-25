//
//  Dog.swift
//  DogDiary
//
//  Created by Ingyu Woo on 8/25/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import Firebase


protocol DocumentSerializable {
    init?(dictionary:[String:Any])
}

struct Dog {
    var name: String
    var breed: String
    var memo: String
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "breed": breed,
            "memo": memo
        ]
    }
}

extension Dog: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let breed = dictionary["breed"] as? String,
            let memo = dictionary["memo"] as? String
            else { return nil }
        
        self.init(name: name,
                  breed: breed,
                  memo: memo)
    }
    
}
