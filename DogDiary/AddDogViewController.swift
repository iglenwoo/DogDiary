//
//  AddDogViewController.swift
//  DogDiary
//
//  Created by Ingyu Woo on 8/24/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseFirestore

class AddDogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dogDetailTableView: UITableView = UITableView()
    var dogNameText: UITextField = UITextField()
    var dogNameCell: UITableViewCell = UITableViewCell()
    var dogBreedText: UITextField = UITextField()
    var dogBreedCell: UITableViewCell = UITableViewCell()
    var dogMemoText: UITextField = UITextField()
    var dogMemoCell: UITableViewCell = UITableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Dog Details"
        
        let saveButton: UIBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        self.navigationItem.rightBarButtonItem = saveButton

        setupDogDetails()
        setupDogDetailTableView()
    }
    
    @objc func saveTapped() {
        var ref: DocumentReference? = nil
        
        guard let dogName = dogNameText.text, !dogName.isEmpty else {
            displayAlert(message: "Please enter your dog name")
            return
        }
        let dogMemo = dogNameText.text ?? ""
        let dogBreed = dogBreedText.text ?? ""
        
        guard let user = Auth.auth().currentUser else {
            fatalError("Failed to get current uer")
        }
        
        let newDog = Dog(documentId: nil, name: dogName, breed: dogBreed, memo: dogMemo)
        
        self.view.activityStartAnimating(activityColor: .white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        
        ref = LocalData.sharedInstance.db.collection("users").document(user.uid).collection("dogs").addDocument(data: newDog.dictionary) { (err) in
            if let err = err {
                print("Error adding document: \(err)")
                self.view.activityStopAnimating()
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.view.activityStopAnimating()
                self.dogNameText.text = ""
                self.dogBreedText.text = ""
                self.dogMemoText.text = ""
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    private func displayAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupDogDetails() {
        dogNameText = UITextField(frame: dogNameCell.bounds.insetBy(dx: 15, dy: 0))
        dogNameText.placeholder = "Name"
        dogNameCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        dogNameCell.addSubview(dogNameText)
        
        dogBreedText = UITextField(frame: dogBreedCell.bounds.insetBy(dx: 15, dy: 0))
        dogBreedText.placeholder = "Breed"
        dogBreedCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        dogBreedCell.addSubview(dogBreedText)
        
        dogMemoText = UITextField(frame: dogMemoCell.bounds.insetBy(dx: 15, dy: 0))
        dogMemoText.placeholder = "Memo"
        dogMemoCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        dogMemoCell.addSubview(dogMemoText)
    }
    
    private func setupDogDetailTableView() {
        dogDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dogDetailTableView)
        
        dogDetailTableView.dataSource = self
        dogDetailTableView.delegate = self
        
        dogDetailTableView.separatorStyle = .none
        dogDetailTableView.allowsMultipleSelection = false
        
        dogDetailTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        dogDetailTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        dogDetailTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        dogDetailTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return 3
        default: fatalError("Unknown number of sections")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            switch(indexPath.row) {
            case 0: return self.dogNameCell
            case 1: return self.dogBreedCell
            case 2: return self.dogMemoCell
            default: fatalError("Unknown row in section 0")
            }
        default: fatalError("Unknown section")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0 : return "Details"
        default: fatalError("Unknown section")
        }
    }

}
