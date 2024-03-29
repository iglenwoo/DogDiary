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
    
    var dogsListener: ListenerRegistration? = nil
    
    let addDogViewController = AddDogViewController()
    let dogsTV = UITableView()
    let cellId = "dogListId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDogsTV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dogsTV.reloadData()
        setupDogsListener()
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
    
    private func setupDogsListener() {
        guard let user = Auth.auth().currentUser else {
            fatalError("Failed to get current uer")
        }
        
        dogsListener = LocalData.sharedInstance.db.collection("users").document(user.uid).collection("dogs")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                var dogs: [Dog] = []
                
                for (_, document) in documents.enumerated() {
                    guard let dog = Dog(documentId: document.documentID, dictionary: document.data()) else {
                        print("Cannot convert document(\(document.documentID)) to Dog")
                        continue
                    }
                    
                    dogs.append(dog)
                }
                
                LocalData.sharedInstance.dogs = dogs
                self.dogsTV.reloadData()
                
                self.navigateToAddIfNoDog()
        }
    }
    
    private func navigateToAddIfNoDog() {
        if LocalData.sharedInstance.dogs.count == 0 {
            let alert = UIAlertController(title: "Add your dogs", message: "Please add your dogs to start activity logging", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.navigationController?.pushViewController(self.addDogViewController, animated: true)
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.dogsListener?.remove()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocalData.sharedInstance.dogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let dog = LocalData.sharedInstance.dogs[indexPath.row]
        var dogLabel = "\(dog.name)"
        if !dog.breed.isEmpty {
            dogLabel.append(contentsOf: "(\(dog.breed))")
        }
        cell.textLabel?.text = dogLabel
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        LocalData.sharedInstance.selectedDogIndex = indexPath.row
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let user = Auth.auth().currentUser else {
                fatalError("Failed to get current uer")
            }
            guard let documentId = LocalData.sharedInstance.dogs[indexPath.row].documentId else {
                print("Fatiled to get a dog documentId")
                return
            }
            
            LocalData.sharedInstance.db.collection("users").document(user.uid).collection("dogs").document(documentId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }

            // remove the item from the data model
            LocalData.sharedInstance.dogs.remove(at: indexPath.row)
            
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.navigateToAddIfNoDog()
        }
    }
}
