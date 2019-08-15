//
//  TrackViewController.swift
//  DogDiary
//
//  Created by Ingyu Woo on 8/3/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit

class TrackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tracking"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My Dog", style: .plain, target: self, action: #selector(yourButtonClickAction))
    }

    @objc func myDogTapped() {
        //TODO: check if my dog is already set
        //TODO: open a popup
    }
    
    @IBAction func yourButtonClickAction(sender: UIBarButtonItem) {
        let dogVC = DogViewController()
        let nav = UINavigationController(rootViewController: dogVC)
        nav.modalPresentationStyle = .popover
        if let presentation = nav.popoverPresentationController {
            presentation.sourceView = self.view
        }
        present(nav, animated: true, completion: nil)
    }
    
    //TODO: delete it maybe
    @objc func closePopover() {
    
    }
}

