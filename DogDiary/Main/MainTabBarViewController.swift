//
//  MainTabBarViewController.swift
//  DogDiary
//
//  Created by Ingyu Woo on 8/3/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit
import FirebaseUI

class MainTabBarViewController: UITabBarController {

    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
            openLoginView()
        } else {
            print("[MainTabBarController] Current user is \"\(Auth.auth().currentUser.debugDescription)\"")
            self.selectedIndex = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        debugPrint("[MainTabBarController] viewWillAppear called")
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            debugPrint(user ?? "[MainTabBarController] addStateDidChangeListener called");
            if ((user) == nil) {
                debugPrint("[MainTabBarController] Signed out?")
                self.openLoginView()
            } else {
                debugPrint("[MainTabBarController] Signed in?")
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        debugPrint("[MainTabBarController] viewWillDisappear called")
        Auth.auth().removeStateDidChangeListener(handle!)
        debugPrint("[MainTabBarController] removeStateDidChangeListener called")
    }
}

extension MainTabBarViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error != nil {
            debugPrint(error?.localizedDescription ?? "error?")
            return
        }
        
        let uid = authDataResult!.user.uid
        let email = authDataResult!.user.email ?? "none"
        debugPrint("[MainTabBarController] uid is \"\(uid)\"")
        debugPrint("[MainTabBarController] email is \"\(email)\"")
    }
}

extension MainTabBarViewController {
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
