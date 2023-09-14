//
//  AccountViewController.swift
//  RiderPDF
//
//  Created by Igor Kononov on 11.09.2023.
//

import Foundation
import UIKit
import FirebaseAuth

final class AccountViewController: UIViewController {
    let nameLabel = UILabel()
    let signOutButton = UIButton(type: .system)
    let deleteAccountButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpNameLabel()
        setUpSignOutButton()
        setUpDeleteAccountButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

    }
    
    private func setUpNameLabel() {
       let user = Auth.auth().currentUser
        
        nameLabel.text = user?.displayName ?? "no name"
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50)
        ])
    }
    private func setUpSignOutButton() {
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signOutButton)
        
        NSLayoutConstraint.activate([
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20)
        ])
    }
    private func setUpDeleteAccountButton() {
        deleteAccountButton.setTitle("Delete Account", for: .normal)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
        deleteAccountButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(deleteAccountButton)
        
        NSLayoutConstraint.activate([
            deleteAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteAccountButton.topAnchor.constraint(equalTo: signOutButton.bottomAnchor, constant: 20)
        ])
    }
    
    @objc func signOutButtonTapped() {
        do {
            try Auth.auth().signOut()
            
            let authViewController = AuthViewController()
            if let navigationController = self.navigationController {
                self.tabBarController?.tabBar.isHidden = true
                navigationController.pushViewController(authViewController, animated: true)
            }
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    @objc func deleteAccountButtonTapped() {
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                print("Error deleting account: \(error.localizedDescription)")
            } else {
                print("Account deleted successfully")
                
                let authViewController = AuthViewController()
                if let navigationController = self.navigationController {
                    self.tabBarController?.tabBar.isHidden = true
                    navigationController.pushViewController(authViewController, animated: true)
                }
            }
        }
    }
}
