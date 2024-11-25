//
//  SceneDelegate.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 23/11/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        self.window?.rootViewController = LoginViewController()
        self.window?.makeKeyAndVisible()
    }
}

