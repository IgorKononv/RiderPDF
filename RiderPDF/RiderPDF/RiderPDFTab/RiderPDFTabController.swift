//
//  ViewController.swift
//  RiderPDF
//
//  Created by Igor Kononov on 11.09.2023.
//

import UIKit
import FirebaseAuth

final class RiderPDFTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
        setUpColors()
        addTopShadow()
    }
    
    private func setUpColors() {
        self.tabBar.tintColor = .purple
        self.tabBar.unselectedItemTintColor = .black
        self.tabBar.backgroundColor = .white
    }
    
    private func setUpTabs() {
        let myFiles = self.createNav(title: "Files", image: "doc.plaintext.fill", vc: FilesViewController())
        let myTools = self.createNav(title: "Tools", image: "wrench.and.screwdriver", vc: ToolsViewController())
        let myAccount = self.createNav(title: "Account", image: "person.circle", vc: AccountViewController())

        self.setViewControllers([myFiles, myTools, myAccount], animated: true)
        
        [myFiles, myTools, myAccount].forEach { navController in
            navController.isNavigationBarHidden = true
        }
    }
    
    private func createNav(title: String, image: String, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = UIImage(systemName: image)
        
        return nav
    }
    
    private func addTopShadow() {
        let shadowView = UIView(frame: CGRect(x: 0, y: -1, width: tabBar.frame.width, height: 0.5))
        shadowView.backgroundColor = .black
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1)
        shadowView.layer.shadowRadius = 2
        tabBar.addSubview(shadowView)
    }
}
