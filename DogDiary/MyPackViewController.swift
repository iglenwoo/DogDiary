//
//  DogViewController.swift
//  DogDiary
//
//  Created by Ingyu Woo on 8/13/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit
import FirebaseUI

class MyPackViewController: UIViewController {
    
    //TODO: add new dog
    //TODO: fetch dog list
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("DogViewController viewDidLoad")
        
        buildUI()
    }
    
    private func buildUI() {
        title = "My Pack"
        
        let closeButton: UIBarButtonItem = UIBarButtonItem(title: "close", style: .plain, target: self, action: #selector(closeTapped))
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc func closeTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
            openLoginView()
        } else {
            debugPrint("[DogViewController] Current user is \"\(Auth.auth().currentUser.debugDescription)\"")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        debugPrint("[DogViewController] viewWillAppear called")
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            debugPrint(user ?? "[DogViewController] addStateDidChangeListener called");
            if ((user) == nil) {
                debugPrint("[DogViewController] Signed out?")
                self.openLoginView()
            } else {
                debugPrint("[DogViewController] Signed in?")
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        debugPrint("[DogViewController] viewWillDisappear called")
        Auth.auth().removeStateDidChangeListener(handle!)
        debugPrint("[DogViewController] removeStateDidChangeListener called")
    }
    
}

extension MyPackViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error != nil {
            debugPrint(error?.localizedDescription ?? "error?")
            return
        }
        
        let uid: String = authDataResult!.user.uid
        let email: String = authDataResult!.user.email ?? "none"
        debugPrint("[DogViewController] uid is \"\(uid)\"")
        debugPrint("[DogViewController] email is \"\(email)\"")
    }
}

extension MyPackViewController {
    func openLoginView() {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth()]
        
        authUI?.providers = providers
        let authViewController = authUI!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
}
