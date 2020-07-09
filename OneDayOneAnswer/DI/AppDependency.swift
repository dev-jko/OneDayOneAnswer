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
}

extension AppDependency {
    static func resolve() -> AppDependency {

        let database: DataBase = SqliteDataBase.instance

        let todayViewControllerFactory = { date in TodayViewController(dataBase: database, date: date) }

        let displayViewControllerFactory = { date in
            return DisplayViewController(
                todayViewControllerFactory: todayViewControllerFactory,
                dataBase: database,
                date: date
            )
        }

        let listViewControllerFactory = {
            return ListViewController(
                displayViewControllerFactory: displayViewControllerFactory,
                dataBase: database
            )
        }

        let privateAnswerViewControllerFactory: PrivateAnswerViewControllerFactory = {
            let listVC = listViewControllerFactory()
            return PrivateAnswerViewController(rootViewController: listVC)
        }

        let rootTabBarControllerFactory = {
            return RootTabBarController(privateAnswerViewControllerFactory: privateAnswerViewControllerFactory)
        }

        return AppDependency(rootTabBarControllerFactory: rootTabBarControllerFactory)
    }
}

typealias RootTabBarControllerFactory = () -> RootTabBarController
typealias PrivateAnswerViewControllerFactory = () -> PrivateAnswerViewController
typealias DisplayViewControllerFactory = (Date) -> DisplayViewController
typealias TodayViewControllerFactory = (Date) -> TodayViewController
