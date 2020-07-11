//
//  SignManager.swift
//  OneDayOneAnswer
//
//  Created by Jaedoo Ko on 2020/06/13.
//  Copyright © 2020 JMJ. All rights reserved.
//

import FirebaseAuth
import GoogleSignIn

class SignManager {

    static let shared = SignManager()

    var user: User?

    var isLoggedIn: Bool {
        return user != nil
    }

    private init() { }

    func signOut() {
        guard isLoggedIn else { return }
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}

class GoogleSignInDelegate: NSObject, GIDSignInDelegate {

    static let shared: GoogleSignInDelegate = GoogleSignInDelegate()

    // MARK: - Lifecycle

    private override init() {
        super.init()
    }

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
