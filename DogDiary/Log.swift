//
//  Log.swift
//  DogDiary
//
//  Created by Ingyu Woo on 8/25/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import Firebase

struct Log {
    var documentId: String?
    var actionType: String
    var dogId: String
    var dogName: String
    var timestamp: Timestamp
    
    var dictionary: [String: Any] {
        return [
            "actionType": actionType,
            "dogId": dogId,
            "dogName": dogName,
            "timestamp": timestamp
        ]
    }
}

extension Log: DocumentSerializable {
    
    init?(documentId: String? = nil, dictionary: [String : Any]) {
        guard let actionType = dictionary["actionType"] as? String,
            let dogId = dictionary["dogId"] as? String,
            let dogName = dictionary["dogName"] as? String,
            let timestamp = dictionary["timestamp"] as? Timestamp
            else { return nil }
        
        self.init(documentId: documentId,
                  actionType: actionType,
                  dogId: dogId,
                  dogName: dogName,
                  timestamp: timestamp)
    }
    
}
