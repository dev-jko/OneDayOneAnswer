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
        GIDSignIn.sharedInstance()?.delegate = appDependency.googleSignInDelegateFactory()

        self.window = UIWindow()
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = appDependency.rootTabBarControllerFactory()

        sleep(2)
        return true
    }

}
