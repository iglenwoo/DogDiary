//
//  SettingViewController.swift
//  DogDiary
//
//  Created by Ingyu Woo on 8/13/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {

    let logOutButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Setting"
        
        setupLogOutButton()
    }
    
    private func setupLogOutButton() {
        logOutButton.backgroundColor = .green
        logOutButton.setTitle("Log out", for: .normal)
        logOutButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        logOutButton.center = self.view.center
        
        self.view.addSubview(logOutButton)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        LocalData.sharedInstance.dogs = []
        LocalData.sharedInstance.logs = []
        LocalData.sharedInstance.selectedDogIndex = -1
        
        try! Auth.auth().signOut()
    }
}
