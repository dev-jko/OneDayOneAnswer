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
        label.textColor = .white
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        provideDependency()
        setLoadingSpinner()
        setErrorView()
    }

    func provideDependency() {
        preconditionFailure("This method must be overridden")
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

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        state = .loading
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        state = .loading
        super.init(coder: coder)
    }
}
