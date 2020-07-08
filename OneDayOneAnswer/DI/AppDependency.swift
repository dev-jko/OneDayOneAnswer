//
//  AppDependency.swift
//  OneDayOneAnswer
//
//  Created by Jaedoo Ko on 2020/07/08.
//  Copyright © 2020 JMJ. All rights reserved.
//

import Foundation

struct AppDependency {
    let rootTabBarControllerFactory: () -> RootTabBarController
}

extension AppDependency {
    static func resolve() -> AppDependency {

        let database: DataBase = SqliteDataBase.instance

        let todayViewControllerFactory = { TodayViewController(dataBase: database) }

        let displayViewControllerFactory = {
            return DisplayViewController(
                todayViewControllerFactory: todayViewControllerFactory,
                dataBase: database
            )
        }

        let listViewControllerFactory = {
            return ListViewController(
                displayViewControllerFactory: displayViewControllerFactory,
                dataBase: database
            )
        }

        let privateAnswerViewControllerFactory: () -> PrivateAnswerViewController = {
            let listVC = listViewControllerFactory()
            return PrivateAnswerViewController(rootViewController: listVC)
        }

        let rootTabBarControllerFactory = {
            return RootTabBarController(privateAnswerViewControllerFactory: privateAnswerViewControllerFactory)
        }

        return AppDependency(rootTabBarControllerFactory: rootTabBarControllerFactory)
    }
}

