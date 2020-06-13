//
//  SignInViewController.swift
//  OneDayOneAnswer
//
//  Created by Jaedoo Ko on 2020/06/12.
//  Copyright © 2020 JMJ. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInViewController: BaseViewController {

    lazy var signInBtn: GIDSignInButton = {
        let btn = GIDSignInButton()
        btn.addTarget(self, action: #selector(signInBtnClicked), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    lazy var closeBtn: UIButton = {
       let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "close_black").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .darkGray
        btn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    @objc
    func signInBtnClicked() {
        state = .loading
    }

    @objc
    func btnClicked() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        GIDSignIn.sharedInstance()?.presentingViewController = self
    }

    override func setAutoLayout() {
        super.setAutoLayout()

        view.addSubview(signInBtn)
        view.addSubview(closeBtn)

        [
            signInBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            closeBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            closeBtn.widthAnchor.constraint(equalToConstant: 60),
            closeBtn.heightAnchor.constraint(equalToConstant: 60)

        ].forEach { $0.isActive = true }
    }

}
