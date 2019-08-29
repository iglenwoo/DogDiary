//
//  AddDogViewController.swift
//  DogDiary
//
//  Created by Ingyu Woo on 8/24/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit

class AddDogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dogDetailTableView: UITableView = UITableView()
    var dogNameText: UITextField = UITextField()
    var dogNameCell: UITableViewCell = UITableViewCell()
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
        //TODO: save data to Firestore
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupDogDetails() {
        dogNameText = UITextField(frame: dogNameCell.bounds.insetBy(dx: 15, dy: 0))
        dogNameText.placeholder = "Name"
        dogNameCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        dogNameCell.addSubview(dogNameText)
        
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
        case 0: return 2
        default: fatalError("Unknown number of sections")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            switch(indexPath.row) {
            case 0: return self.dogNameCell
            case 1: return self.dogMemoCell
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
