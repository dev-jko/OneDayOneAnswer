//
//  TabBarItemStyles.swift
//  OneDayOneAnswer
//
//  Created by Jaedoo Ko on 2020/07/07.
//  Copyright © 2020 JMJ. All rights reserved.
//

import UIKit

private func baseTabBarItemStyle(item: UITabBarItem) -> UITabBarItem {
    item.title = nil
    return item
}

public func privateAnswerTabBarItemStyle() -> (UITabBarItem) -> UITabBarItem {
    return baseTabBarItemStyle
        <> { $0.title = "나의 기록"; return $0 }
        <> { $0.image = #imageLiteral(resourceName: "round_menu_book_black_36pt"); return $0 }
}

public func sharedAnswerTabBarItemStyle() -> (UITabBarItem) -> UITabBarItem {
    return baseTabBarItemStyle
        <> { $0.title = "같이 보기"; return $0 }
        <> { $0.image = #imageLiteral(resourceName: "baseline_forum_black_36pt"); return $0 }
}

public func profileTabBarItemStyle() -> (UITabBarItem) -> UITabBarItem {
    return baseTabBarItemStyle
        <> { $0.title = "My"; return $0 }
        <> { $0.image = #imageLiteral(resourceName: "baseline_person_black_36pt"); return $0 }
}
