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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My Pack", style: .plain, target: self, action: #selector(myDogTapped))
    }

    @objc func myDogTapped() {
        let dogVC = DogViewController()
        let nav = UINavigationController(rootViewController: dogVC)
        nav.modalPresentationStyle = .popover
        if let presentation = nav.popoverPresentationController {
            presentation.sourceView = self.view
        }
        present(nav, animated: true, completion: nil)
    }

}
