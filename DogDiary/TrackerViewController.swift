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
    let dogTV = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTrackVC()
        setupDogTV()
    }
    
    private func setupTrackVC() {
        title = "Tracking"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My Pack", style: .plain, target: self, action: #selector(myPackTapped))
    }
    
    private func setupDogTV() {
        dogTV.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(dogTV)
        
        dogTV.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0).isActive = true
        dogTV.topAnchor.constraint(equalTo: view.topAnchor, constant: 8.0).isActive = true
        dogTV.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8.0).isActive = true
        dogTV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8.0).isActive = true
        
        dogTV.delegate = self
        dogTV.dataSource = self
        dogTV.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "\(indexPath)"
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // etc
    }
}
