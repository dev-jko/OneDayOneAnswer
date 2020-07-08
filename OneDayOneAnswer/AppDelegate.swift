//
//  AppDelegate.swift
//  OneDayOneAnswer
//
//  Created by Mihye Kim on 23/04/2020.
//  Copyright © 2020 JMJ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let appDependency: AppDependency = AppDependency.resolve()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self

        self.window = UIWindow()
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = appDependency.rootTabBarControllerFactory()

        sleep(2)
        return true
    }

}

extension AppDelegate: GIDSignInDelegate {

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance()?.handle(url) ?? false
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let vc = signIn.presentingViewController as? BaseViewController {
            vc.state = .success
        }
        if let error = error {
            print(error)
            return
        }

        guard let auth = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            if let _ = authResult {
                SignManager.shared.user = Auth.auth().currentUser
                signIn.presentingViewController.dismiss(animated: true, completion: nil)
            }
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
            return
        }
    }

}
