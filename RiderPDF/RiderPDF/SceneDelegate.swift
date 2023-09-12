//
//  SceneDelegate.swift
//  RiderPDF
//
//  Created by Igor Kononov on 11.09.2023.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScane = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScane.coordinateSpace.bounds)
        window?.windowScene = windowScane
        window?.rootViewController = RiderPDFTabController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }


}

