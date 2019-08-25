//
//  DogViewController.swift
//  DogDiary
//
//  Created by Ingyu Woo on 8/13/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit
import FirebaseFirestore

class MyPackViewController: UIViewController {
    
    //TODO: add new dog
    //TODO: fetch dog list
//    let db = Firestore.firestore()
//    var dogsRef: CollectionReference? = nil
    
    let addDogViewController = AddDogViewController()
    let logOptionsTV = UITableView()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        dogsRef = db.collection("dogs")
        buildUI()
    }
    
    private func buildUI() {
        title = "My Pack"
        
        let addButton: UIBarButtonItem = UIBarButtonItem(title: "add", style: .plain, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addTapped() {
        self.navigationController?.pushViewController(addDogViewController, animated: true)
    }
    
}
