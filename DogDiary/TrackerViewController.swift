//
//  TrackViewController.swift
//  DogDiary
//
//  Created by Ingyu Woo on 8/3/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit

enum TrackerOption: String, CaseIterable {
    case Eat
    case Poop
    case Pee
    case Play
    case Walk
    
    init?(id : Int) {
        switch id {
        case 1: self = .Eat
        case 2: self = .Poop
        case 3: self = .Pee
        case 4: self = .Play
        case 5: self = .Walk
        default: return nil
        }
    }
}

class TrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // TODO: hook Firebase
    var selectedDog = "Moongchi"
//    var dogs: [Dog]
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
        button.setTitle(selectedDog, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(changeDog), for: .touchUpInside)
        navigationItem.titleView = button
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My Pack", style: .plain, target: self, action: #selector(myPackTapped))
    }
    
    @objc func changeDog() {
        // TODO: Show a picker to choose a dog
        selectedDog = "M9"
        button.setTitle(selectedDog, for: .normal)
    }
    
    @objc func myPackTapped() {
        let myPackVC = MyPackViewController()
        navigationController?.pushViewController(myPackVC, animated: true)
    }
    
    private func setupTrackV() {
        logOptionsTV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logOptionsTV)
        
        logOptionsTV.separatorStyle = .none
        logOptionsTV.allowsMultipleSelection = true
        
        logOptionsTV.dataSource = self
        logOptionsTV.delegate = self
        logOptionsTV.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        logOptionsTV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        logOptionsTV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        logOptionsTV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        logOptionsTV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionTitle = ""
        switch (section) {
        case 0: sectionTitle = "Choose single/multiple options"
        default: break
        }
        return sectionTitle
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO - open a view to confirm the log?
        // two lines below are only for testing
        selectedDog = trackerOptions[indexPath.row].rawValue
        button.setTitle(selectedDog, for: .normal)
    }
}
