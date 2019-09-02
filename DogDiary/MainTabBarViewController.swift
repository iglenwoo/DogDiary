//
//  MainTabBarViewController.swift
//  DogDiary
//
//  Created by Ingyu Woo on 8/3/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseFirestore

class MainTabBarViewController: UITabBarController {

    var authHandle: AuthStateDidChangeListenerHandle?
    
//    static let db = Firestore.firestore()
    
    var dogsListener: ListenerRegistration? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("[\(String(describing: MainTabBarViewController.self))] viewDidLoad")
        
        // Required by Firestore
        let settings = LocalData.sharedInstance.db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        LocalData.sharedInstance.db.settings = settings
        
        setupVCs()
    }
    
    private func setupVCs() {
        let trackVC = TrackerViewController()
        trackVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
    
        let historyVC = HistoryViewController()
        historyVC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
    
        let settingVC = SettingViewController()
        settingVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
    
        let vcs = [trackVC, historyVC, settingVC]
        self.viewControllers = vcs.map { UINavigationController(rootViewController: $0) }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("[\(String(describing: MainTabBarViewController.self))] viewDidAppear")
        
        if Auth.auth().currentUser == nil {
            openLoginView()
        } else {
            guard let user = Auth.auth().currentUser else {
                fatalError("Failed to get current uer")
            }
            debugPrint("[\(String(describing: MainTabBarViewController.self))] Current user is \"\(user.debugDescription)\"")
            
            self.selectedIndex = 0
            setupDogsListener(uid: user.uid)
        }
    }
    
    private func setupDogsListener(uid: String) {
        dogsListener = LocalData.sharedInstance.db.collection("users").document(uid).collection("dogs")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                var dogs: [Dog] = []
                
                for (index, document) in documents.enumerated() {
                    guard let dog = Dog(documentId: document.documentID, dictionary: document.data()) else {
                        print("Cannot convert document(\(document.documentID)) to Dog")
                        continue
                    }
                    
                    if (dog.selected) {
                        LocalData.sharedInstance.selectedDogIndex = index
                        //todo: bind selectedIdx || refactor `selected`
                    }
                    dogs.append(dog)
                }
                
                LocalData.sharedInstance.dogs = dogs
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        debugPrint("[\(String(describing: MainTabBarViewController.self))] viewWillAppear")
        authHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
            debugPrint(user ?? "[\(String(describing: MainTabBarViewController.self))] addStateDidChangeListener called");
            if ((user) == nil) {
                debugPrint("[\(String(describing: MainTabBarViewController.self))] Signed out?")
                self.openLoginView()
            } else {
                debugPrint("[\(String(describing: MainTabBarViewController.self))] Signed in?")
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        debugPrint("[\(String(describing: MainTabBarViewController.self))] viewWillDisappear called")
        Auth.auth().removeStateDidChangeListener(authHandle!)
        debugPrint("[\(String(describing: MainTabBarViewController.self))] removeStateDidChangeListener called")
    }
}

extension MainTabBarViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        debugPrint("[\(String(describing: MainTabBarViewController.self))] FUIAuthDelegate")
        if error != nil {
            debugPrint(error?.localizedDescription ?? "error?")
            return
        }
        
        let uid: String = authDataResult!.user.uid
        let email: String = authDataResult!.user.email ?? "none"
        debugPrint("[\(String(describing: MainTabBarViewController.self))] uid is \"\(uid)\"")
        debugPrint("[\(String(describing: MainTabBarViewController.self))] email is \"\(email)\"")
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
