//
//  TableViewStyles.swift
//  OneDayOneAnswer
//
//  Created by Jaedoo Ko on 2020/07/12.
//  Copyright © 2020 JMJ. All rights reserved.
//

import UIKit

private func baseTableViewStyle(tableView: UITableView) -> (UITableView) {
    tableView.backgroundColor = .clear
    tableView.showsVerticalScrollIndicator = false
    tableView.isHidden = true
    return tableView
}

public func defaultTableViewStyle() -> (UITableView) -> (UITableView) {
    return baseTableViewStyle
}
