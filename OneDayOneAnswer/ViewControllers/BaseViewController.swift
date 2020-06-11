//
//  BaseViewController.swift
//  OneDayOneAnswer
//
//  Created by Jaedoo Ko on 2020/06/03.
//  Copyright © 2020 JMJ. All rights reserved.
//

import UIKit

enum LoadingState {
    case loading
    case success
    case failure
}

class BaseViewController: UIViewController {
    var provider: Provider?
    var state: LoadingState {
        didSet { print(state) }
    }

    let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.hidesWhenStopped = true
        view.stopAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        state = .loading
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        state = .loading
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        provideDependency()

    }

    func provideDependency() {

    }
}
