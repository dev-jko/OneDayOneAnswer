//
//  RootTabbarController.swift
//  OneDayOneAnswer
//
//  Created by Jaedoo Ko on 2020/07/07.
//  Copyright © 2020 JMJ. All rights reserved.
//

import UIKit

// MARK: - RootViewControllerData

public enum RootViewControllerData {
    case privateAnswer
    case sharedAnswer
    case profile(isLoggedIn: Bool)
}

// MARK: - TabBarItem

public enum TabBarItem {
    case privateAnswer(index: Int)
    case sharedAnswer(index: Int)
    case profile(index: Int)
}

// MARK: - UITabBarController

class RootTabBarController: UITabBarController {

    // MARK: - properties

    private let privateAnswerViewControllerFactory: () -> PrivateAnswerViewController

    // MARK: - initializers

    init(
        privateAnswerViewControllerFactory: @escaping () -> PrivateAnswerViewController
    ) {
        self.privateAnswerViewControllerFactory = privateAnswerViewControllerFactory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        let vcData: [RootViewControllerData] = [.privateAnswer, .sharedAnswer, .profile(isLoggedIn: false)]
        let vcs: [UIViewController] = vcData.map(self.viewController(from:))
        self.setViewControllers(vcs, animated: true)

        let tabBarItems: [TabBarItem] = [.privateAnswer(index: 0), .sharedAnswer(index: 1), .profile(index: 2)]
        setTabBarItemStyles(items: tabBarItems)
    }

    // MARK: - method

    private func viewController(from data: RootViewControllerData) -> UIViewController {
        switch data {
        case .privateAnswer:
            return privateAnswerViewControllerFactory()
        case .sharedAnswer:
            return SharedAnswerViewController()
        case .profile(let isLoggedIn):
            return isLoggedIn ? ProfileViewController() : SignInViewController()
        }
    }

    private func tabBarItem(atIndex index: Int) -> UITabBarItem? {
        guard self.tabBar.items?.count ?? 0 > index,
            let item = self.tabBar.items?[index] else { return nil }
        return item
    }

    private func setTabBarItemStyles(items: [TabBarItem]) {
        items.forEach { item in
            switch item {
            case .privateAnswer(let index):
                _ = tabBarItem(atIndex: index) ?|> privateAnswerTabBarItemStyle()
            case .sharedAnswer(let index):
                _ = tabBarItem(atIndex: index) ?|> sharedAnswerTabBarItemStyle()
            case .profile(let index):
                _ = tabBarItem(atIndex: index) ?|> profileTabBarItemStyle()
            }
        }
    }
}

// MARK: - UITabBarControllerDelegate

extension RootTabBarController: UITabBarControllerDelegate {

}
