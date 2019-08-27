//
//  HistoryViewController.swift
//  DogDiary
//
//  Created by Ingyu Woo on 8/3/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseFirestore

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var logsListener: ListenerRegistration? = nil
    
    let logsTV = UITableView()
    let cellId = "LogCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "History"
        
        logsTV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logsTV)
        
        logsTV.dataSource = self
        logsTV.delegate = self
        logsTV.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        logsTV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        logsTV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        logsTV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        logsTV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    deinit {
        logsListener = nil
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let user = Auth.auth().currentUser else {
            fatalError("Failed to get current uer")
        }
        
        setupLogsListener(uid: user.uid)
    }

    private func setupLogsListener(uid: String) {
        logsListener = LocalData.sharedInstance.db.collection("users").document(uid).collection("logs")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                var logs: [Log] = []
                
                for (_, document) in documents.enumerated() {
                    guard let log = Log(dictionary: document.data()) else {
                        print("Cannot convert document(\(document.documentID)) to Dog")
                        continue
                    }
                    
                    logs.append(log)
                }
                
                LocalData.sharedInstance.logs = logs
                self.logsTV.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocalData.sharedInstance.logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let dogName = LocalData.sharedInstance.logs[indexPath.row].dogName
        let actionType = LocalData.sharedInstance.logs[indexPath.row].actionType
        let timestamp = LocalData.sharedInstance.logs[indexPath.row].timestamp
        let date = timestamp.dateValue()
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm dd"
        let strDate = dateFormatter.string(from: date)
        cell.textLabel?.text = "\(dogName) \(actionType) \(strDate)"
        
        return cell
    }
}

