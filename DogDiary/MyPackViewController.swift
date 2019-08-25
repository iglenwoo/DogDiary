//
//  DogViewController.swift
//  DogDiary
//
//  Created by Ingyu Woo on 8/13/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseFirestore

class MyPackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //TODO: add new dog
    let db = Firestore.firestore()
    
    var dogsListener: ListenerRegistration? = nil
    
    let addDogViewController = AddDogViewController()
    let dogsTV = UITableView()
    let cellId = "dogListId"
    var dogs: [Dog] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        guard let user = Auth.auth().currentUser else {
            fatalError("Failed to get current uer")
        }
        let uid = user.uid
        
        setupUI()
        setupDogsTV()
        
        dogsListener = db.collection("users").document(uid).collection("dogs")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                var dogs: [Dog] = []
                
                for document in documents {
                    guard let dog = Dog(dictionary: document.data()) else {
                        print("Cannot convert document to Dog")
                        continue
                    }
                    dogs.append(dog)
                }
                
                self.dogs = dogs
                self.dogsTV.reloadData()
        }
    }
    
    deinit {
        dogsListener = nil
    }
    
    private func setupUI() {
        title = "My Pack"
        
        let addButton: UIBarButtonItem = UIBarButtonItem(title: "add", style: .plain, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addTapped() {
        navigationController?.pushViewController(addDogViewController, animated: true)
    }
    
    private func setupDogsTV() {
        dogsTV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dogsTV)
        
        dogsTV.separatorStyle = .singleLine
        dogsTV.allowsMultipleSelection = false
        
        dogsTV.dataSource = self
        dogsTV.delegate = self
        dogsTV.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        dogsTV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        dogsTV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        dogsTV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        dogsTV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let dog = dogs[indexPath.row]
        cell.textLabel?.text = "\(dog.name) (\(dog.breed))"
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: logic
    }
}
