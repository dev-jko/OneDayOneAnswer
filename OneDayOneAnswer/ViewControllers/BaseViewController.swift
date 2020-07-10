//
//  BaseViewController.swift
//  OneDayOneAnswer
//
//  Created by Jaedoo Ko on 2020/06/03.
//  Copyright © 2020 JMJ. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

enum LoadingState {
    case loading
    case success
    case failure
}

class BaseViewController: UIViewController {

    var state: LoadingState {
        didSet {
            switch state {
            case .loading:
                onLoading()
            case .success:
                onLoadingSuccess()
            case .failure:
                onLoadingFailure()
            }
        }
    }

    let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.hidesWhenStopped = true
        view.stopAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let errorView: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "DXPnMStd-Regular", size: 24)
        label.text = "불러오기 중\n문제가 발생했습니다."
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func setLoadingSpinner() {
        view.addSubview(loadingView)

        [
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)

        ].forEach { $0.isActive = true }
    }

    func setErrorView() {
        view.addSubview(errorView)

        [
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor)

        ].forEach { $0.isActive = true }
    }

    func setAutoLayout() {
        setLoadingSpinner()
        setErrorView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setAutoLayout()
    }

    func onLoading() {
        view.bringSubviewToFront(loadingView)
        loadingView.startAnimating()
        errorView.isHidden = true
    }

    func onLoadingSuccess() {
        loadingView.stopAnimating()
    }

    func onLoadingFailure() {
        view.bringSubviewToFront(errorView)
        errorView.isHidden = false
        loadingView.stopAnimating()
    }

    init() {
        self.state = .loading
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var handle: AuthStateDidChangeListenerHandle?
}

extension BaseViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (_, _) in

        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handle = self.handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }

    }
}
