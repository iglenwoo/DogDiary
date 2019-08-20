//
//  TrackViewController.swift
//  DogDiary
//
//  Created by Ingyu Woo on 8/3/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit

class TrackerViewController: UIViewController {
    
    // TODO: finish dog tableview
    var safeArea: UILayoutGuide!
    
    var selectedDog = "Moongchi"
    let button =  UIButton(type: .custom)
    
    let logOptionsTV = UITableView()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = view.layoutMarginsGuide
        setupNav()
        setupTrackV()
    }
    
    private func setupNav() {
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.setTitle(selectedDog, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
        navigationItem.titleView = button
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My Pack", style: .plain, target: self, action: #selector(myPackTapped))
    }
    
    @objc func clickOnButton() {
        // TODO: Show a picker
        selectedDog = "M9"
        button.setTitle(selectedDog, for: .normal)
    }
    
    private func setupTrackV() {
        logOptionsTV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logOptionsTV)
        
        logOptionsTV.dataSource = self
        logOptionsTV.delegate = self
        logOptionsTV.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        logOptionsTV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        logOptionsTV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        logOptionsTV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        logOptionsTV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc func myPackTapped() {
        let dogVC = MyPackViewController()
        let nav = UINavigationController(rootViewController: dogVC)
        nav.modalPresentationStyle = .popover
        if let presentation = nav.popoverPresentationController {
            presentation.sourceView = self.view
        }
        present(nav, animated: true, completion: nil)
    }
    
}

extension TrackerViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = "\(indexPath)"
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // etc
    }
}
