//
//  TrackViewController.swift
//  DogDiary
//
//  Created by Ingyu Woo on 8/3/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseFirestore

class TrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let button =  UIButton(type: .custom)
    
    var trackerOptions: [TrackerOption] = []
    let logOptionsTV = UITableView()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for option in TrackerOption.allCases {
            trackerOptions.append(option)
        }
        
        setupNav()
        setupTrackV()
    }
    
    private func setupNav() {
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        if LocalData.sharedInstance.selectedDogIndex > -1 && LocalData.sharedInstance.selectedDogIndex <= LocalData.sharedInstance.dogs.count - 1 {
            updateTitle()
        }
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(changeDog), for: .touchUpInside)
        navigationItem.titleView = button
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My Pack", style: .plain, target: self, action: #selector(myPackTapped))
    }
    
    @objc func changeDog() {
        // TODO: Show a picker to choose a dog
        button.setTitle(LocalData.sharedInstance.dogs[LocalData.sharedInstance.selectedDogIndex].name, for: .normal)
    }
    
    @objc func myPackTapped() {
        let myPackVC = MyPackViewController()
        navigationController?.pushViewController(myPackVC, animated: true)
    }
    
    private func setupTrackV() {
        logOptionsTV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logOptionsTV)
        
        logOptionsTV.separatorStyle = .none
        
        logOptionsTV.dataSource = self
        logOptionsTV.delegate = self
        logOptionsTV.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        logOptionsTV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        logOptionsTV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        logOptionsTV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        logOptionsTV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateTitle()
    }
    
    private func updateTitle() {
        self.button.setTitle(LocalData.sharedInstance.getCurrentDogName(), for: .normal)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackerOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = "\(trackerOptions[indexPath.row])"
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        logOptionsTV.deselectRow(at: indexPath, animated: true)
        guard let selectedDog = LocalData.sharedInstance.getCurrentDog() else {
            print("Choose your dog")
            return
        }
        guard let dogId = selectedDog.documentId else {
            print("documentId is nil (\(selectedDog.name))")
            return
        }
        
        var ref: DocumentReference? = nil
        
        guard let user = Auth.auth().currentUser else {
            fatalError("Failed to get current uer")
        }
        let actionType = trackerOptions[indexPath.row]
        let timestamp = Timestamp()
        let newLog = Log(documentId: nil, actionType: actionType.rawValue, dogId: dogId, dogName: selectedDog.name, timestamp: timestamp)
        self.tabBarController?.selectedIndex = 1
        ref = LocalData.sharedInstance.db.collection("users").document(user.uid).collection("logs").addDocument(data: newLog.dictionary) { (err) in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                //polish: loading?
                
            }
        }
    }
}
