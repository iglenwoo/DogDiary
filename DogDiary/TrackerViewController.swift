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
    
    let myPackVC = MyPackViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for option in TrackerOption.allCases {
            trackerOptions.append(option)
        }
        
        setupNav()
        setupTrackV()
    }
    
    private func setupNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My Pack", style: .plain, target: self, action: #selector(myPackTapped))
        
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(changeDog), for: .touchUpInside)
        navigationItem.titleView = button
    }
    
    @objc func changeDog() {
        // polish: Show a picker to choose a dog
        button.setTitle(LocalData.sharedInstance.dogs[LocalData.sharedInstance.selectedDogIndex].name, for: .normal)
    }
    
    @objc func myPackTapped() {
//        let myPackVC = MyPackViewController()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let currentDogName = LocalData.sharedInstance.getCurrentDog()?.name {
            self.button.setTitle(currentDogName, for: .normal)
        } else {
            self.button.setTitle("", for: .normal)
            let alert = UIAlertController(title: "Select your dog?", message: "Please select your dog to log his or her activity", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.navigationController?.pushViewController(self.myPackVC, animated: true)
            }))
            
            self.view.activityStartAnimating(activityColor: .white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.activityStopAnimating()
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
