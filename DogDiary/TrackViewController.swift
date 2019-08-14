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
        //TODO: fix this, not working as expected
        let popover = DogViewController()
        popover.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(closePopover))
        popover.modalPresentationStyle = .popover
        if let presentation = popover.popoverPresentationController {
//            presentation.barButtonItem = navigationItem.rightBarButtonItem
            presentation.barButtonItem = sender
        }
        present(popover, animated: true, completion: nil)
    }
    
    //TODO: delete it maybe
    @objc func closePopover() {
    
    }
}

