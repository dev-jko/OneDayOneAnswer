//
//  AppDependency.swift
//  OneDayOneAnswer
//
//  Created by Jaedoo Ko on 2020/07/08.
//  Copyright © 2020 JMJ. All rights reserved.
//

import Foundation

struct AppDependency {
    let rootTabBarControllerFactory: RootTabBarControllerFactory
    let googleSignInDelegateFactory: GoogleSignInDelegateFactory
}

extension AppDependency {
    static func resolve() -> AppDependency {

        let databaseFactory: DataBaseFactory = { SqliteDataBase.instance }
        let googleSignInDelegateFactory: GoogleSignInDelegateFactory = { GoogleSignInDelegate.shared }

        let todayViewControllerFactory = { date in
            TodayViewController(dataBase: databaseFactory(), date: date)
        }

        let displayViewControllerFactory = { date in
            return DisplayViewController(
                todayViewControllerFactory: todayViewControllerFactory,
                dataBase: databaseFactory(),
                date: date
            )
        }

        let listViewControllerFactory = {
            return ListViewController(
                displayViewControllerFactory: displayViewControllerFactory,
                dataBase: databaseFactory()
            )
        }

        let privateAnswerViewControllerFactory: PrivateAnswerViewControllerFactory = {
            let listVC = listViewControllerFactory()
            return PrivateAnswerViewController(rootViewController: listVC)
        }

        let rootTabBarControllerFactory = {
            return RootTabBarController(privateAnswerViewControllerFactory: privateAnswerViewControllerFactory)
        }

        return AppDependency(
            rootTabBarControllerFactory: rootTabBarControllerFactory,
            googleSignInDelegateFactory: googleSignInDelegateFactory
        )
    }
}

typealias DataBaseFactory = () -> DataBase
typealias GoogleSignInDelegateFactory = () -> GoogleSignInDelegate
typealias RootTabBarControllerFactory = () -> RootTabBarController
typealias PrivateAnswerViewControllerFactory = () -> PrivateAnswerViewController
typealias DisplayViewControllerFactory = (Date) -> DisplayViewController
typealias TodayViewControllerFactory = (Date) -> TodayViewController
