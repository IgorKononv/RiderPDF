//
//  AuthViewController.swift
//  RiderPDF
//
//  Created by Igor Kononov on 14.09.2023.
//

import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

final class AuthViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpGoogleButton()
    }
    
    private func setUpGoogleButton() {
        let googleButton = GIDSignInButton()
        let width = 200.0
        let height = 50.0
        googleButton.frame = CGRect(x: (view.frame.size.width - width) / 2, y: (view.frame.size.height - height) / 2, width: width, height: height)
        googleButton.addTarget(self, action: #selector(sign), for: .touchUpInside)
        view.addSubview(googleButton)
        
    }
    
    @objc private func sign() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                print("Google Sign-In Error: \(error!.localizedDescription)")
                return }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Firebase Sign-In Error: \(error.localizedDescription)")
                    return
                }
                print("Firebase Sign-In Successful")
                
                let riderPDFTabController = RiderPDFTabController()
                
                if let nC = self.navigationController {
                     
                    if nC.viewControllers.count > 1 {
                        nC.popViewController(animated: true)
                        self.tabBarController?.tabBar.isHidden = true
                    } else {
                        nC.pushViewController(riderPDFTabController, animated: true)
                    }
                }
            }
        }
    }
}









    
