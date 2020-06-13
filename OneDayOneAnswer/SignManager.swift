//
//  SignManager.swift
//  OneDayOneAnswer
//
//  Created by Jaedoo Ko on 2020/06/13.
//  Copyright © 2020 JMJ. All rights reserved.
//

import FirebaseAuth

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
